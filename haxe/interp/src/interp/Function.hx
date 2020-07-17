package interp;
import interp.Command;
using interp.CommandTools;

@:enum abstract Function(String) 
{
	var inc;
	var dec;
	var neg;
	var add;
	var mul;
	var div;
	var lt;
	var eq;
	var s;
	var c;
	var b;
	var t;
	var f;
	var pwr2;
	var i;
	var cons;
	var car ;
	var cdr ;
	
	public function getRequiredSize():Int
	{
		return switch ((cast this:Function))
		{
			case inc : 1;
			case dec : 1;
			case neg : 1;
			case add : 2;
			case mul : 2;
			case div : 2;
			case lt  : 2;
			case eq  : 2;
			case s   : 3;
			case c   : 3;
			case b   : 3;
			case t   : 2;
			case f   : 2;
			case pwr2: 1;
			case i   : 1;
			case cons: 3;
			case car : 1;
			case cdr : 1;
		}
	}
	
	public function execute(args:Array<Command>):Command
	{
		var func = (cast this:Function);
		return try 
		{
			switch (func)
			{
				case inc: Command.Int (args[0].toInt() + 1);
				case dec: Command.Int (args[0].toInt() - 1);
				case neg: Command.Int (-args[0].toInt());
				case add: Command.Int (args[0].toInt() + args[1].toInt());
				case mul: Command.Int (args[0].toInt() * args[1].toInt());
				case div: 
					var x1 = args[1].toInt();
					if (x1 == 1)
					{
						args[0];
					}
					else
					{
						Command.Int (Std.int(args[0].toInt() / x1));
					}
				case eq : Command.Bool(args[0].toString() == args[1].toString());
				case lt : Command.Bool(args[0].toInt() <  args[1].toInt());
				case s:
					args[0].ap(args[2]).ap(args[1].ap(args[2]));
				case c:
					args[0].ap(args[2]).ap(args[1]);
				case b:
					args[0].ap(args[1].ap(args[2]));
				case t:
					args[0];
				case f:
					args[1];
				case pwr2:
					var x0 = 1; 
					for (i in 0...args[0].toInt())
					{
						x0 = x0 * 2;
					}
					Command.Int(x0);
					
				case i:
					args[0];
					
				case cons:
					args[2].ap(args[0]).ap(args[1]);
				
				case car:
					switch (args[0])
					{
						case Command.Func(Function.cons, [x0, x1]):
							x0;
							
						case arg:
							args[0].ap(Command.Func(Function.t, []));
					}
					
				case cdr: 
					return switch (args[0])
					{
						case Command.Func(Function.cons, [x0, x1]):
							x1;
							
						case arg:
							args[0].ap(Command.Func(Function.f, []));
					}
			}
		}
		catch (e:TypeError)
		{
			Command.Func(func, args);
		}
	}
	
	public function toString():String
	{
		return this;
	}
}
