package gui.root;
import gui.Top;
import framework.tree.NodeHolder;
import gui.root.layout.LayoutStorage;

class RootStorage extends NodeHolder
{
	@:absorb
	@:forward(logic)
	private var top:Top;
	
	private var layout:LayoutStorage;
	
	public function new(parent:NodeHolder) 
	{
		super(parent);
		this.layout = new LayoutStorage(this, logic.layout);
	}
	
	public function update():Void
	{
		if (!node.synchronizeVersion(logic.node))
		{
			return;
		}
		
		layout.update();
	}
}
