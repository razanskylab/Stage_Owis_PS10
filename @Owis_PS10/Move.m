% File: Move.m @ Owis_PS10
% Author: Urs Hofmann
% Mail: hofmannu@ethz.ch
% Date: 15.07.2021

function Move(ow, pos)

	ow.targetMode = 1;

	ret = calllib('ps10', 'PS10_SetTarget', 1, 1, pos);
	ow.Read_Error(ret);

	ret = calllib('ps10', 'PS10_GoTarget', 1, 1);
	ow.Read_Error(ret);

end