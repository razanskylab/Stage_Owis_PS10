% File: Disconnect.m @ Owis_PS10
% Author: Urs Hofmann
% Mail: hofmannu@ethz.ch
% Date: 15.07.2021

% Closes connection to owis stage

function Disconnect(op)

	fprintf('[Owis_PS10] Disconnect... ');
	ret = calllib('ps10', 'PS10_Disconnect', 1);

	if ret == 0
		fprintf('done!\n');
		op.isConnected = 0;
	else
		error('function error');
	end
	
end