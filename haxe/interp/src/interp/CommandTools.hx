package interp;
import interp.Command;

class CommandTools 
{
	public static function toString(result:Command):String
	{
		return switch (result)
		{
			case Command.Bool(b): if (b) "t" else "f";
			case Command.Int (i): Std.string(i);
			case Func(func, args):
				var result = func.toString();
				for (arg in args)
				{
					result = "ap " + result + " " + toString(arg);
				}
				result;
				
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
			case Command.Func(f, a):
				func = f;
				args = a;
				
			case _:
				throw "ap x: must be function";
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
