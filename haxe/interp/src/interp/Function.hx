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
	var lt;
	var eq;
	var s;
	var c;
	var b;
	var t;
	
	public function getRequiredSize():Int
	{
		return switch ((cast this:Function))
		{
			case inc: 1;
			case dec: 1;
			case neg: 1;
			case add: 2;
			case mul: 2;
			case lt : 2;
			case eq : 2;
			case s  : 3;
			case c  : 3;
			case b  : 3;
			case t  : 2;
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
