package interp;

import java.Lib;

/**
 * ...
 * @author shohei909
 */
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
		while (env.commands.length > 0)
		{
			var error = env.eval();
			if (error != null) 
			{
				Sys.stderr().writeString("error: " + error + "\n");
				return;
			}
		}
		
		Sys.stdout().writeString("= " + env.result.join(" ") + "\n");
	}
	
}

private class Environment
{
	public var commands:Array<String>;
	public var result:Array<String>;
	
	public function new(commands:Array<String>)
	{
		this.commands = commands;
		result = [];
	}
	
	public function eval():String
	{
		var data = commands.pop();
		if (data == "ap")
		{
			var command = result.pop();
			if (command == "inc")
			{
				var a = Std.parseInt(result.pop());
				if (a == null) return "inc a should be number:" + a;
				result.push(Std.string(a += 1));
			}
			else if (command == "dec")
			{
				var a = Std.parseInt(result.pop());
				if (a == null) return "dec a should be number:" + a;
				result.push(Std.string(a -= 1));
			}
			else
			{
				return "ap: unknown command:" + command;
			}
		}
		else
		{
			result.push(data);
		}
		return null;
	}
}
