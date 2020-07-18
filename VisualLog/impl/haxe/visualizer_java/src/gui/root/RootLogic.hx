package gui.root;

import framework.command.CommandQueue;
import framework.tree.NodeHolder;
import gui.menu.MenuLogic;
import gui.player.PlayerLogic;
import gui.root.layout.LayoutLogic;

class RootLogic extends NodeHolder
{
	@:absorb
	private var top:Top;
	
	public var player(default, null):PlayerLogic;
	public var layout(default, null):LayoutLogic;
	public var menu(default, null):MenuLogic;
	public var viewQueue(default, null):CommandQueue<RootViewCommand>;
	
	public function new(parent:NodeHolder)
	{
		super(parent);
		
		layout = new LayoutLogic(this);
		player = new PlayerLogic(this);
		menu   = new MenuLogic(this);
		
		viewQueue = top.gate.createQueue(
			this, 
			RootCommand.LayoutView, 
			onViewCommand
		);
	}
	
	public function update():Void
	{
	}
	
	private function onViewCommand(command:RootViewCommand):Void
	{
		switch (command)
		{
			case RootViewCommand.Close(data):
				layout.applyLayout(data);
		}
	}
}
