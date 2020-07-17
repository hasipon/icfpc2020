package interp;

import interp.Command;
using interp.CommandTools;

class Main 
{
	static function main() 
	{
		for (i in 0...0x7FFFFFFF)
		{
			waitInpt();
		}
	}
	
	static function waitInpt():Void
	{
		var line = Sys.stdin().readLine();
		var env = new Environment(line.split(" "));
		while (env.input.length > 0)
		{
			try
			{
				env.exec();
			}
			catch (error:Dynamic)
			{
				Sys.stderr().writeString("error: " + error + "\n");
			}
		}
		
		Sys.stdout().writeString("=");
		while (env.output.length > 0)
		{
			Sys.stdout().writeString(" " + env.output.pop().toString());
		}
		Sys.stdout().writeString("\n");
	}
	
}

private class Environment
{
	public var input:Array<String>;
	public var output:Array<Command>;
	
	public function new(input:Array<String>)
	{
		this.input = input;
		output = [];
	}
	
	public function exec():Void
	{
		var data = input.pop();
		
		var command = getCommand(data);
		output.push(command);
	}
	
	public function getCommand(data:String):Command
	{
		if (data == "ap")
		{
			var func, args;
			var c = output.pop();
			if (c == null) "ap x: too short args";
			switch (c)
			{
				case Command.Func(f, a):
					func = f;
					args = a;
					
				case _:
					throw "ap x: must be function";
			}
			
			var na = output.pop();
			if (na == null) "ap x: too short args";
			args.push(na);
			var required = func.getRequiredSize();
			return if (args.length == required)
			{
				func.execute(args);
			}
			else
			{
				Command.Func(func, args);
			}
		}
		if (data == "inc")
		{
			return Command.Func(Function.inc, []);
		}
		if (data == "dec")
		{
			return Command.Func(Function.dec, []);
		}
		if (data == "add")
		{
			return Command.Func(Function.add, []);
		}
		if (data == "t")
		{
			return Command.Bool(true);
		}
		if (data == "f")
		{
			return Command.Bool(false);
		}
		var int = Std.parseInt(data);
		if (int != null)
		{
			return Command.Int(int);
		}
		
		return Command.Unknown(data);
	}
}
