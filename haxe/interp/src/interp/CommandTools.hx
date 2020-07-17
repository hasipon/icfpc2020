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
	public static function toString(result:Command):String
	{
		return switch (result)
		{
			case Command.Int (i): Std.string(i);
			case Func(func, args):
				var result = func.toString();
				for (arg in args)
				{
					result = "ap " + result + " " + toString(arg);
				}
				result;
				
			case Command.Ap(a, b):
				"ap " + toString(a) + " " + toString(b);
				/*
			case Command.List(list):
				var result = "(";
				var first = true;
				for (element in list) 
				{
					if (first)
					{
						result += " ";
					}
					else
					{
						result += " , ";
					}
					result += arrayToString(element);
					first = false;
				}
				result + " )";
				*/
			case Command.Unknown(string):
				string;
		}
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
			throw "ap x: too long args";
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
