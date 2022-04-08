% File: Owis_PS10.m @ Owis_PS10
% Author: Urs Hofmann
% Mail: hofmannu@ethz.ch
% Date: 14.07.2021

function Connect(op, varargin)

	fprintf('[Owis_PS10] Opening connection... ');

	ret = calllib('ps10','PS10_Connect', 1, 0, ...
		op.COM_PORT, 9600, 0, 0, 8, 0);

	switch ret
		case 0
			fprintf('done!\n');
			op.isConnected = 1;
		case 1
			error('function error, wrong parameters');
		case 3 
			error('invalid port, could not find it');
		case 4
			error('could not access port, in use already?'); 
		case 5
			error('device is not responding, check cables');
		case 9
			error('no connection to windows tcp socket');
		otherwise
			error('system returned unknown error code');
	end

end