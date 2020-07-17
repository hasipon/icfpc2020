package interp;
import interp.Command;

class CommandTools 
{
	
	public static function arrayToString(commands:Array<Command>):String
	{
		var result = "";
		var first = true;
		for (command in commands)
		{
			if (!first)
			{
				result += " ";
			}
			result += toString(command);
			first = false;
		}
		return result;
	}
	public static function toString(command:Command):String
	{
		var result = "";
		var commands = [command];
		var first = true;
		while (0 < commands.length)
		{
			if (!first) result += " ";
			result += switch (commands.pop())
			{
				case Command.Int (i): Std.string(i);
				
				case Command.Ap(a, b):
					commands.push(b);
					commands.push(a);
					"ap"; 
					
				case Func(func, args):
					var name = func.toString();
					for (i in 0...args.length)
					{
						name = "ap " + name;
						commands.push(args[args.length - i - 1]);
					}
					name;
					
				case Command.Unknown(string):
					string;
					
				case Command.Assign(key, value):
					key + " = " + arrayToString(value);
			}
			first = false;
		}
		return result;
	}
	
	
	public static function toInt(result:Command):Int
	{
		return switch (result)
		{
			case Command.Int(i): i;
			case _: throw new TypeError(toString(result) + " should be int");
		}
	}
	public static function ap(c:Command, na:Command):Command
	{
		var func, args;
		switch (c)
		{
			case Command.Func(_func, a):
				func = _func;
				args = a;
				
			case _:
				return Command.Ap(c, na);
		}
		var required = func.getRequiredSize();
		if (args.length == required) 
		{
			return Command.Ap(c, na);
		}
		args.push(na);
		
		return if (args.length == required)
		{
			func.execute(args);
		}
		else
		{
			Command.Func(func, args);
		}
	}
}
