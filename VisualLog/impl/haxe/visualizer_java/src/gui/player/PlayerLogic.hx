package gui.player;
import framework.tree.INodeHolder;
import framework.tree.NodeHolder;
import gui.player.document.DocumentLogic;

class PlayerLogic extends NodeHolder
{
	public var documents:Array<DocumentLogic>;
	public var loaded(get, never):Bool;
	private function get_loaded():Bool 
	{
		if (documents.length == 0) return false;
		for (document in documents)
		{
			if (!document.loaded) return false;
		}
		return true;
	}
	
	public var playing:Bool;
	public var currentStep(default, null):Int;
	public var maxStep(default, null):Int;
	
	public function new(parent:INodeHolder) 
	{
		super(parent);
		
		documents = [];
		
		playing = false;
		currentStep = 0;
		maxStep = 0;
		node.incrementVersion();
	}
	
	public function load(path:String):Void
	{
		documents.push(new DocumentLogic(this, path));
	}
}
