package interp;
import interp.Command;
using interp.CommandTools;

@:enum abstract Function(String) 
{
	var inc;
	var dec;
	var add;
	
	public function getRequiredSize():Int
	{
		return switch ((cast this:Function))
		{
			case inc: 1;
			case dec: 1;
			case add: 2;
		}
	}
	
	public function execute(args:Array<Command>):Command
	{
		return switch ((cast this:Function))
		{
			case inc: Command.Int(args[0].toInt() + 1);
			case dec: Command.Int(args[0].toInt() - 1);
			case add: Command.Int(args[0].toInt() + args[1].toInt());
		}
	}
	
	public function toString():String
	{
		return this;
	}
}
