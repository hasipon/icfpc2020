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
		}
	}
	
	public function execute(args:Array<Command>):Command
	{
		return switch ((cast this:Function))
		{
			case inc: Command.Int(args[0].toInt() + 1);
			case dec: Command.Int(args[0].toInt() - 1);
			case neg: Command.Int(-args[0].toInt());
			case add: Command.Int(args[0].toInt() + args[1].toInt());
			case mul: Command.Int(args[0].toInt() * args[1].toInt());
			case eq : Command.Bool(args[0].toInt() == args[1].toInt());
			case lt : Command.Bool(args[0].toInt() <  args[1].toInt());
		}
	}
	
	public function toString():String
	{
		return this;
	}
}
