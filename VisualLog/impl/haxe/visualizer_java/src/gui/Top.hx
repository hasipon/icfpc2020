package gui;

import framework.command.CommandGate;
import framework.command.write.SimpleCommandWriter;
import framework.tree.NodeHolder;
import gui.root.RootCommand;
import gui.root.RootLogic;
import gui.root.RootView;
import gui.root.RootStorage;
import haxe.Timer;

class Top extends NodeHolder
{
	public var gate:CommandGate<RootCommand>;
	public var storage:RootStorage;
	public var logic:RootLogic;
	public var view:RootView;
	
	public function new()
	{
		super(null);
		diffuse(Top);
		
		gate = new CommandGate(this, new SimpleCommandWriter());
		logic = new RootLogic(this);
		storage = new RootStorage(this);
        view = new RootView(this);
		
		Timer.delay(update, Std.int(1000 / 60));
	}
	
	private function update():Void
	{
		gate.update();
		logic.update();
		storage.update();
		view.update();
		
		Timer.delay(update, Std.int(1000 / 60));
	}
}
