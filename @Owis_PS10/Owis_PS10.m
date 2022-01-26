% File: Owis_PS10.m @ Owis_PS10
% Author: Urs Hofmann
% Mail: hofmannu@ethz.ch
% Dtae: 14.07.2021

% TODO:
%		*  Autmoatically find correct COM Port
% 	*  make get functions for isHomed and isEnabled from controller

classdef Owis_PS10 < handle

	properties
		isHomed(1, 1) logical = 0;
		isEnabled(1, 1) logical = 0;

		COM_PORT(1, 1) int32 = 14;
		beSilent(1, 1) logical = 0;
	end

	properties(SetAccess = private)
		isConnected(1, 1) logical = 0;
	end

	properties (Constant)
		pitch(1, 1) single = 1; % how much distance per rev [mm]
		stepsPerRev(1, 1) single = 200; % number of incremental steps per rev
		gRatio(1, 1) single = 50; % gear ratio
	end

	properties(Constant, Hidden)
		libraryPath(1, :) char = 'C:\Program Files (x86)\OWISoft\ps10\sdk\zAdditional_software_interfaces\MatLab\ps10.h'; 
		dllPath = 'C:\Program Files (x86)\OWISoft\Application\ps10.dll';
		posMin(1, 1) single = 0; % minimum position we are allowed to move to
		posMax(1, 1) single = 20; % maximum position we can move to
	end

	properties(Dependent)
		pos(1, 1) single;
		vel(1, 1) single;
		acc(1, 1) single;
		motorType(1, :) char;
		timeout(1, 1) single; % 0 means no timeout, otherwise in [ms]
		microstepMode(1, 1) single;
		driveCurrent(1, 1) single;
		holdCurrent(1, 1) single;
		inc_to_mm(1, 1) single;
		mm_to_inc(1, 1) single;
		maxPos(1, 1) single;
		refSwitch(1, 1) int32;
		velRF(1, 1) single; % fast velocity for a reference drive [Hz]
		velRS(1, 1) single; % slow velocity for a reference drive [Hz]
		targetMode(1, 1) int32; % 0: relative positioning, 1: absolute posit
	end
	
	methods

		% class constructor
		function Owis_PS10 = Owis_PS10(~)
			% only load library if not existing
			if ~libisloaded('ps10')
				[notfound, warnings] = loadlibrary(...
					Owis_PS10.dllPath, Owis_PS10.libraryPath, ...
					'alias', 'ps10');
			end

			% open connection to stage
			Owis_PS10.Connect();
			Owis_PS10.Init();
		end

		% class desctructor
		function delete(obj)
			obj.Disconnect();
		end

		% externally defined functions
		Connect(ow, varargin);
		Disconnect(ow);
		Init(ow); % initialize stage
		Read_Error(ow, varargin); % can be overloaded with existing error code
		Home(ow); % move stage to lower reference point and declare as 0
		Move(ow, pos);
		Wait_Move(ow);

		function targetMode = get.targetMode(op)
			targetMode = calllib('ps10', 'PS10_GetTargetMode', 1, 1);
			op.Read_Error();
		end

		function set.targetMode(op, targetMode)
			ret = calllib('ps10', 'PS10_SetTargetMode', 1, 1, targetMode);
			op.Read_Error(ret);
		end

		% set and get functions
		function maxPos = get.maxPos(op)
			maxPos = calllib('ps10', 'PS10_GetPosRange', 1, 1);
			maxPos = maxPos * op.inc_to_mm;
			op.Read_Error();
		end

		function velRF = get.velRF(op)
			velRF = calllib('ps10', 'PS10_GetFastRefF', 1, 1);
			velRF = velRF * op.inc_to_mm;
			op.Read_Error();
		end

		function set.velRF(op, velRF)
			velRF = velRF * op.mm_to_inc;
			ret = calllib('ps10', 'PS10_SetFastRefF', 1, 1, velRF);
			op.Read_Error(ret);
		end

		function velRS = get.velRS(op)
			velRS = calllib('ps10', 'PS10_GetSlowRefF', 1, 1);
			velRS = velRS * op.inc_to_mm;
			op.Read_Error();
		end

		function set.velRS(op, velRS)
			velRS = velRS * op.mm_to_inc;
			ret = calllib('ps10', 'PS10_SetSlowRefF', 1, 1, velRS);
			op.Read_Error(ret);
		end

		function set.vel(op, vel)
			vel = vel * op.mm_to_inc;
			ret = calllib('ps10', 'PS10_SetFreeF', 1, 1, vel);
			op.Read_Error(ret);
		end

		function vel = get.vel(op)
			vel = calllib('ps10', 'PS10_GetFreeF', 1, 1);
			vel = vel * op.inc_to_mm;
			op.Read_Error();
		end

		function refSwitch = get.refSwitch(op)
			refSwitch = calllib('ps10', 'PS10_GetRefSwitch', 1, 1);
			op.Read_Error();
		end

		function set.refSwitch(op, refSwitch)
			ret = calllib('ps10', 'PS10_SetRefSwitch', 1, 1, refSwitch);
			op.Read_Error(ret);
		end

		function inc_to_mm = get.inc_to_mm(op)
			inc_to_mm = single(op.pitch) / single(op.stepsPerRev) / single(op.gRatio);
		end

		function mm_to_inc = get.mm_to_inc(op)
			mm_to_inc = single(op.stepsPerRev) * single(op.gRatio) / single(op.pitch); 
		end

		function pos = get.pos(op)
			pos = calllib('ps10', 'PS10_GetPosition', 1, 1);
			pos = pos * op.inc_to_mm;
			err = calllib('ps10', 'PS10_GetReadError', 1);
		end

		function set.pos(op, pos)
			pos = pos * op.mm_to_inc;
			op.Move(pos); % does not wait for the movement to finish
			op.Wait_Move(); % makes sure that we finish moving before returning to MATLAB
		end

		function acc = get.acc(op)
			acc = calllib('ps10', 'PS10_GetAccel', 1, 1);
			acc = acc.inc_to_mm;
			op.Read_Error();
		end

		function set.acc(op, acc)
			acc = acc * op.mm_to_inc;
			ret = calllib('ps10', 'PS10_SetAccel', 1, 1, acc);
			op.Read_Error(ret);
		end

		function mm = get.microstepMode(op)
			mm = calllib('ps10', 'PS10_GetMicrostepMode', 1, 1);
			op.Read_Error();
		end

		function set.microstepMode(op, mm)
			ret = calllib('ps10', 'PS10_SetMicrostepMode', 1, 1, mm);
			op.Read_Error(ret);
		end

		function dc = get.driveCurrent(op)
			dc = calllib('ps10', 'PS10_GetDriveCurrent', 1, 1);
			op.Read_Error();
		end

		function set.driveCurrent(op, dc)
			ret = calllib('ps10', 'PS10_SetDriveCurrent', 1, 1, dc);
			op.Read_Error(ret);
		end

		function hc = get.holdCurrent(op)
			hc = calllib('ps10', 'PS10_GetHoldCurrent', 1, 1);
			op.Read_Error();
		end

		function set.holdCurrent(op, hc)
			ret = calllib('ps10', 'PS10_SetHoldCurrent', 1, 1, hc);
			op.Read_Error(ret);
		end

		function mt = get.motorType(op)
			ret = calllib('ps10', 'PS10_GetMotorType', 1, 1);
			if ret == 0
				mt = 'dc-brush';
			elseif ret == 1
				mt = 'stepper open loop';
			else
				error('unkown motor type connected');
			end
			op.Read_Error();
		end

		function to = get.timeout(op)
			to = calllib('ps10', 'PS10_GetAxisMonitor', 1, 1);
			op.Read_Error();
		end

		function set.timeout(op, to)
			fprintf('[Owis_PS10] Defining timeout... ');
			ret = calllib('ps10', 'PS10_SetAxisMonitor', 1, 1, to);
			op.Read_Error(ret);
			fprintf('done!\n');
		end

	end


end