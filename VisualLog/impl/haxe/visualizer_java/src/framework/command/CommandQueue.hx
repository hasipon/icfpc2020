package framework.command;
import framework.tree.INodeHolder;
import framework.tree.NodeHolder;

class CommandQueue<Command> extends NodeHolder
{
	public var commands(default, null):Array<Command>;
	
	public function new(parent:INodeHolder) 
	{
		super(parent);
		node.addDisposeHandler(dispose);
		commands = [];
	}
	
	public inline function execute(handler:Command->Void):Void
	{
		if (!node.disposed) 
		{
			call(handler);
			clear();
		}
	}
	
	public inline function call(handler:Command->Void):Void
	{
		var i = 0;
		while (i < commands.length)
		{
			if (node.disposed) { break; }
			handler(commands[i]);
			i++;
		}
	}
	
	public function clear():Void
	{
		if (node.disposed) { return; }
		commands.splice(0, commands.length);
	}
	
	public function add(command:Command):Void
	{
		if (node.disposed) { return; }
		
		commands.push(command);
	}
	
	private function dispose():Void
	{
		commands = null;
	}
}
