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
			var command = commands.pop();
			result += switch (command)
			{
				case Command.Int (i): Std.string(i);
				case Command.List(elments):
					var first = true;
					var str = "";
					for (element in elments)
					{
						if (!first)
						{
							str += " , ";
						}
						str += toString(element);
						first = false;
					}
					"( " + str + " )";
					
				case Func(func, args):
					var name = func.toString();
					for (i in 0...args.length)
					{
						name = "ap " + name;
						commands.push(args[args.length - i - 1]);
					}
					name;
					
				case Command.Ap(a, b):
					commands.push(b);
					commands.push(a);
					"ap"; 
					
				case Command.Unknown(string):
					string;
					
				case Command.Modulate(result):
					"[" + result.toString() + "]";
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
			
			case Command.List(elements0):
				switch x1 
				{
					case Command.List(elements1):
						if (elements0.length != elements1.length) return MaybeBool.False;
						for (i in 0...elements1.length)
						{
							if (eq(elements0[i], elements1[i]) != MaybeBool.True) return MaybeBool.Unknown;
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
				
			case Command.Modulate(c0):
				switch x1 
				{
					case Command.Modulate(c1) if (c0.eq(c1) == MaybeBool.True):
						MaybeBool.True;
						
					case _:
						MaybeBool.Unknown;
				}
				
		}
	}
	public static function ap(c:Command, na:Command):Command
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
					func.execute(args);
				}
				else
				{
					Command.Func(func, args);
				}
				
			case _:
				Command.Ap(c, na);
		}
	}
	
	public static function modulate(command:Command):Command
	{
		var tasks  = [ModTask.Com];
		var input  = [command];
		var output = [];
		var aps    = [];
		
		inline function addCommand(c:Command):Void
		{
			tasks.push(ModTask.Com);
			input.push(c);
		}
		
		var recCount = 0;
		while (0 < tasks.length)
		{
			switch (tasks.pop())
			{
				case ModTask.Com:
					var command = input.pop();
					switch (command)
					{
						case Command.Ap(c, ap):
							addCommand(c);
							aps.push(ap);
							
						case Command.Func(func, args):
							var required      = func.getRequiredSize ();
							var evalThreshold = func.getEvalThreshold();
							if (evalThreshold <= args.length + aps.length)
							{
								tasks.push(ModTask.Func(func, output.length));
								for (arg in args) 
								{
									
									addCommand(arg);
								}
								for (_ in args.length...required)
								{
									if (aps.length <= 0) break;
									addCommand(aps.pop());
								}
							}
							else
							{
								var newArgs = [];
								for (arg in args) 
								{
									newArgs.push(arg);
								}
								for (_ in args.length...required)
								{
									if (aps.length <= 0) break;
									newArgs.push(aps.pop());
								}
								output.push(Command.Func(func, newArgs));
							}
							
						case Command.List(elements):
							tasks.push(ModTask.EndList(output.length));
							for (element in elements) 
							{
								addCommand(element);
							}
							
						case Command.Modulate(_):
							output.push(command);
						
						case Command.Int(i):
							output.push(command);
							
						case Command.Unknown(string):
							if (Main.variables.exists(string))
							{
								trace(string, recCount);
								addCommand(Main.variables[string].command);
							}
							else
							{
								output.push(command);
							}
					}
					
				case ModTask.EndList(length):
					var list = [];
					for (_ in length...output.length)
					{
						list.push(output.pop());
					}
					output.push(Command.List(list));
					
				case ModTask.Func(func, length):
					var args = [];
					for (_ in length...output.length)
					{
						args.push(output.pop());
					}
					var required = func.getRequiredSize();
					var result = if (args.length == required)
					{
						var result = func.execute(args);
						if (200 < recCount)
						{
							recCount = 0;
							result;
						}
						else 
						if (result.eq(Command.Func(func, args)) == MaybeBool.True)
						{
							result;
						}
						else
						{
							recCount += 1;
							addCommand(result);
							continue;
						}
					}
					else 
					{
						Command.Func(func, args);
					}
					switch (result)
					{
						case Command.Func(Function.cons, [x0, Command.Func(Function.nil, [])]):
							result = Command.List([x0]);
							
						case Command.Func(Function.cons, [x0, Command.List(elements)]):
							result = Command.List([x0].concat(elements));
							
						case _:
					}
					output.push(result);
			}
		}
		
		var result = output[0];
		while (aps.length > 0)
		{
			result = Command.Ap(result, modulate(aps.pop()));
		}
		return result;
	}
	public static function dem(command:Command):Command
	{
		return switch (command)
		{
			case Command.Func(Function.mod, [x0]):
				x0;
				
			case arg:
				Command.Func(Function.dem, [arg]);
		}
	}
}

enum ModTask
{
	Com;
	EndList(size:Int);
	Func(func:Function, size:Int);
}
