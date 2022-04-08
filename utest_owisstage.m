%utest_Owisstage

O = Owis_PS10();
% constructor automatically opens connection

for i=1:10
	O.Disconnect();
	O.Connect();
end

% moves stage to positive and negative home switch
O.Home();
if (O.isHomed ~= 1)
	error("Homing did not work");
end

testPos = single(0:0.2:20);
for iPos = 1:length(testPos)
	O.pos = testPos(iPos);
	readPos = O.pos;
	errorVal = abs(readPos - testPos(iPos));
	if (errorVal > 1e-3)
		errMsg = sprintf("Wrong position: %.6f instead of %.6f", ...
			readPos, testPos(iPos));
		error(errMsg);
	end
end

testVel = 0.1:0.01:0.5;
for iVel = 1:length(testVel)
	O.vel = testVel(iVel);
	if (O.vel ~= testVel(iVel))
		errMsg = sprintf("Wrong velocity: %.2f instead of %.2f", ...
			O.vel, testVel(iVel));
		error("Wrong velocity");
	end
end

clear O;