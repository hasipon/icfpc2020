package gui.menu;
import framework.command.CommandQueue;
import framework.tree.NodeHolder;
import gui.root.RootCommand;

class MenuLogic extends NodeHolder
{
	@:absorb
	@:forward(logic)
	private var top:Top;
	
	public var hasDialog(default, null):Bool;
	public var viewQueue(default, null):CommandQueue<MenuViewCommand>;
	
	public function new(parent:NodeHolder)
	{
		super(parent);
		
		viewQueue = top.gate.createQueue(
			this, 
			RootCommand.MenuView, 
			onViewCommand
		);
	}
	
	private function onViewCommand(command:MenuViewCommand):Void
	{
		switch (command)
		{
			case MenuViewCommand.Open: 
				hasDialog = true;
			
			case MenuViewCommand.Select(path):
				hasDialog = false;
				if (path != null)
				{
					logic.player.load(path);
				}
		}
		
		node.incrementVersion();
	}
}
