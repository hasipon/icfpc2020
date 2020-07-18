package gui.root.layout;
import framework.command.CommandQueue;
import framework.tree.INodeHolder;
import framework.tree.NodeHolder;
import gui.root.layout.LayoutData;

class LayoutLogic extends NodeHolder
{
	@:absorb
	private var top:Top;
	
	public var data(default, null):LayoutData;
	public var storageQueue(default, null):CommandQueue<LayoutData>;
	
	public function new(parent:INodeHolder)
	{
		super(parent);
		
		storageQueue = top.gate.createQueue(
			this, 
			RootCommand.LayoutStorage, 
			applyLayout
		);
	}
	
	public function applyLayout(layoutData:LayoutData):Void
	{
		data = layoutData;
		node.incrementVersion();
	}
}
