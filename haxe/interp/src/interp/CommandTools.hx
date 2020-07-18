package interp;
import haxe.Int64;
import interp.Command;
using interp.CommandTools;

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
			}
			first = false;
		}
		return result;
	}
	
	
	public static function toInt(result:Command):Int64
	{
		return switch (result)
		{
			case Command.Int(i): i;
			case _: throw new TypeError(toString(result) + " should be int");
		}
	}
	
	public static function add(x0:Command, x1:Command):Command
	{
		return switch [x0, x1]
		{
			case [Command.Int(0), x1]:
				x1;
				
			case [x0, Command.Int(0)]:
				x0;
				
			case  [Command.Int(i0), Command.Func(Function.add, [x0, Command.Int(i1)])]
				| [Command.Int(i0), Command.Func(Function.add, [Command.Int(i1), x0])]
				| [Command.Func(Function.add, [x0, Command.Int(i1)]), Command.Int(i0)]
				| [Command.Func(Function.add, [Command.Int(i1), x0]), Command.Int(i0)]:
				if (i0 + i1 == 0)
				{
					x0;
				}
				else
				{
					Command.Func(Function.add, [x0, Command.Int(i0 + i1)]);
				}
				
			case [Command.Int(x0), Command.Int(x1)]:
				Command.Int(x0 + x1);
			case _:
				Command.Func(Function.add, [x0, x1]);
		}
	}
	public static function eq(x0:Command, x1:Command):MaybeBool
	{
		return switch x0
		{
			case Command.Ap(c0, a0):
				switch x1 
				{
					case Command.Ap(c1, a1):
						if (eq(c0, c1) != MaybeBool.True) return MaybeBool.Unknown;
						if (eq(a0, a1) != MaybeBool.True) return MaybeBool.Unknown;
						MaybeBool.True;
						
					case _:
						MaybeBool.Unknown;
				}
				
			case Command.Func(func0, args0):
				switch x1 
				{
					case Command.Func(func1, args1):
						if (func0 != func1) return MaybeBool.Unknown;
						if (args0.length != args1.length) return MaybeBool.False;
						for (i in 0...args1.length)
						{
							if (eq(args0[i], args1[i]) != MaybeBool.True) return MaybeBool.Unknown;
						}
						MaybeBool.True;
						
					case _:
						MaybeBool.Unknown;
				}
			
			case Command.Int(i0):
				switch x1 
				{
					case Command.Int(i1) if (i0 == i1):
						MaybeBool.True;
						
					case _:
						MaybeBool.False;
				}
				
				
			case Command.Unknown(string0):
				switch x1 
				{
					case Command.Unknown(string1) if (string0 == string1):
						MaybeBool.True;
						
					case _:
						MaybeBool.Unknown;
				}
				
		}
	}
	public static function ap(c:Command, na:Command, shouldEval:Bool):Command
	{
		return switch (c)
		{
			case Command.Func(func, args):
				var required = func.getRequiredSize();
				if (args.length == required) 
				{
					return Command.Ap(c, na);
				}
				
				args = args.copy();
				args.push(na);
				
				if (args.length == required)
				{
					func.execute(args, shouldEval);
				}
				else
				{
					Command.Func(func, args);
				}
				
				/*
			case Command.Unknown(key):
				if (!Main.variables.exists(key))
				{
					return Command.Ap(c, na);
				}
				var v = Main.variables[key];
				if (v.resolveArgLength() != 1)
				{
					return Command.Ap(c, na);
				}
				executeValiables(key, v.command, [na], depth);
				
			case Command.Ap(command, a) if (resolveRestSize(command) == 2):
				var args = [na, a];
				while (true)
				{
					switch (command)
					{
						case Command.Ap(next, a):
							command = next;
							args.push(a);
							
						case Command.Unknown(key) if (Main.variables.exists(key)):
							var v = Main.variables[key];
							
							return executeValiables(key, v.command, args, depth);
							
						case _:
							return Command.Ap(c, na);
					}
				}
				return Command.Ap(c, na);
				*/
				
			case _:
				Command.Ap(c, na);
		}
	}
	
	/*
	public static function executeValiables(key:String, command:Command):Command
	{
	}
	*/
	
	public static var UNKOWN_LENGTH:Int = -99999;
	public static function resolveRestSize(command:Command):Int
	{
		return switch (command)
		{
			case Command.Ap(a, _):
				var size = resolveRestSize(a);
				if (size == UNKOWN_LENGTH) size else size - 1;
				
			case Command.Func(func, args):
				var base = func.getRequiredSize() - args.length;
				return switch [func, args]
				{
					case [i , [a0    ]]: base + resolveRestSize(a0); // A    -> A
					case [t , [a0, _ ]]: base + resolveRestSize(a0); // A, B -> A
					case [f , [_ , a1]]: base + resolveRestSize(a1); // A, B -> B
					case _: base; // Cons
				}
			
			case Command.Int(i):
				0;
				
			case Command.Unknown(string):
				if (Main.variables.exists(string))
				{
					var v = Main.variables[string];
					v.resolveArgLength();
				}
				else
				{
					UNKOWN_LENGTH;
				}
		}
	}
}
