% File: Wait_Move.m @ Owis_PS10
% Author: Urs Hofmann
% Mail: hofmannu@ethz.ch
% Date: 01.08.2021

% Description: Watis until the stage stopped moving

function Wait_Move(ow)

	done = 0;
	while(done == 0)
		moveState = calllib('ps10', 'PS10_GetMoveState', 1, 1);
		ow.Read_Error();
		if (moveState == 0)
			done = 1;
			break;
		else
			pause(0.05); % do nothing
		end
	end

end
