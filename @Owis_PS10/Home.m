% File: Home.m @ Owis_PS10
% Author: Urs Hofmann
% Mail: hofmannu@ethz.ch
% Date: 14.07.2021

% Description: Homes the stage at lower end

function Home(op)

	fprintf('[Owis_PS10] Homing stage... ');
	op.refSwitch = 2;
	op.velRF = -20000 / 10000;
	op.velRS = 2000 / 10000;
	ret = calllib('ps10', 'PS10_GoRef', 1, 1, 6);
	op.Read_Error(ret);

	op.Wait_Move();
	
	op.isHomed = 1;

	fprintf('done!\n');
	% Mode=0 nächsten Index-Impuls suchen und stehenbleiben 
	% Mode=1 Referenzschalter anfahren und stehenbleiben 
	% Mode=2 Referenzschalter anfahren, nächsten Index-Impuls suchen und stehenbleiben 
	% Mode=3 Modus 0, zusätzlich aktuelle Position auf Null setzen 
	% Mode=4 Modus 1, zusätzlich aktuelle Position auf Null setzen 
	% Mode=5 Modus 2, zusätzlich aktuelle Position auf Null setzen 
	% Mode=6 Max. Referenzschalter anfahren, Min. Referenzschalter anfahren, aktuelle Position auf Null setzen 
	% Mode=7 Min. Referenzschalter anfahren, Max. Referenzschalter anfahren, aktuelle Position auf Null setzen 


end
