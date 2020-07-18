package gui.player.document;
import framework.tree.INodeHolder;
import framework.tree.NodeHolder;

class DocumentLogic extends NodeHolder
{
	public var path(default, null):String;
	public var state(default, null):DocumentState;
	public var loaded(get, never):Bool;
	private function get_loaded():Bool 
	{
		return switch (state)
		{
			case DocumentState.Loading: false;
			case DocumentState.Loaded : true;
		}
	}
	public function new(
		parent:INodeHolder,
		path:String
	) 
	{
		super(parent);
		
		this.path = path;
		state = DocumentState.Loading;
	}
}