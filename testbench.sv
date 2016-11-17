class Environment;

	mailbox gen2drv[];
	event drv2gen[];
	Generator gen[];
	Driver drv[];
	Monitor mon[];
	Scoreboard scoreboard;
	virtual interface calc_input_interface, calc_output_interface;

	extern function new(...);
	extern function void build();
	extern task run();

endclass : Environment


function void Environment::build();
	
	//connect generators to drivers
	foreach (gen[i]) begin
		gen[i] = new(gen2drv[i], drv2gen[i]);
		drv[i] = new(gen2drv[i], drv2gen[i], calc_input_interface);
	end

	//connect monitors to calculator
	foreach (mon[i]) begin
		mon[i] = new(calc_output_interface);
	end

	//connect monitors to scoreboard
	begin
		ScoreboardMonitorCallback callback = new(scoreboard);
		foreach(mon[i] mon[i].callback_queue.push_back(callback);
	end

	//connect drivers to scorebord
	begin
		ScoreboardDriverCallback callback = new(scoreboard);
		foreach(drv[i]) drv[i].callback_queue.push_back(callback);
	end

endfunction : build


program automatic test (calc_input_interface, calc_output_interface, output reset);

	Environment env;

	initial begin
		//reset the device and reset logic
		env = new(calc_input_interface, calc_output_interface)
		env.build();
		env.run();
	end

endprogram

	
