package interp;

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
}
