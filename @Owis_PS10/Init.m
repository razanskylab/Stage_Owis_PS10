function Init(op)

	fprintf('[Owis_PS10] Initializing stage... ');

	ret = calllib('ps10', 'PS10_MotorInit', 1, 1);

	switch ret
		case 0
			fprintf('done!\n');
			op.isEnabled = 1;
		case -1
			error('function error');
		case -2
			error('communication error');
		case -3
			error('syntax error');
		otherwise
			error('Returned unknown error code');
	end

end