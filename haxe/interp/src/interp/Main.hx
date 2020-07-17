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
				break;
			}
		}
		
		var first = true;
		while (env.output.length > 0)
		{
			Sys.stdout().writeString(env.output.pop().toString());
			if (!first) Sys.stdout().writeString(" ");
			first = false;
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
			var c  = output.pop();
			if (c == null) throw "ap x: too short args";
			var na = output.pop();
			if (na == null) throw "ap x: too short args";
			return CommandTools.ap(c, na);
			
		}
		for (func in AbstractEnumTools.getValues(Function))
		{
			if (data == func.toString())
			{
				return Command.Func(func, []);
			}	
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
