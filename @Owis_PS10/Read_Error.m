% File: Read_Error.m @ Owis_PS10
% Author: Urs Hofmann
% Mail: hofmannu@ethz.ch
% Date: 14.07.2021

% if nothing is passed: read error, if passed: interpret error

function Read_Error(op, varargin)

	if (nargin == 1)
		ret = calllib('ps10', 'PS10_GetReadError', 1);
	else
		ret = varargin{1};
	end


	switch ret
		case 0
			% fo nothing, everything seems quite nice
		case -1
			error('function error');
		case -2
			error('communication error');
		case -3
			error('syntax error');
		case -4
			error('axis is in wrong state');
		otherwise
			error('invalid error code')	
	end

end