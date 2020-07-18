package framework.tree;
import framework.error.FrameworkError;
import framework.error.FrameworkErrorCode;
import haxe.Int64;
import haxe.macro.Context;
import haxe.macro.TypeTools;

#if macro
import haxe.macro.Expr;
import haxe.macro.ExprTools;
#end

class Node
{
	public var id(default, null):NodeId;
	public var version(default, null):Int;
	public var children(default, null):Array<Node>;
	public var disposed(default, null):Bool;
	private var disposeHandlers(default, null):Array<Void->Void>;
	
	public var parent(default, null):Node;
	private var diffusedData:Map<String, Dynamic>;
	
	public function new(parent:Node)
	{
		id = new NodeId();
		version = 0;
		
		this.parent = parent;
		this.disposed = false;
		this.children = [];
		this.disposeHandlers = [];
		this.diffusedData = new Map();
		
		if (parent != null)
		{
			parent.children.push(this);
			parent.incrementVersion();
		}
	}
	
	public macro function diffuse(value:Expr):Expr
	{
		var key = TypeTools.toString(Context.typeof(value));
		return macro diffuseByKey(value, $v{key});
	}
	
	public function diffuseByKey(value:Dynamic, key:String):Void
	{
		diffusedData[key] = value;
	}
	
	public macro function absorb(type:Expr):Dynamic
	{
		var key = TypeTools.toString(Context.getType(ExprTools.toString(type)));
		return macro absorbByKey($v{key});
	}
	public function absorbByKey(key:String):Dynamic
	{
		return if (diffusedData.exists(key))
		{
			diffusedData[key];
		}
		else if (parent != null)
		{
			parent.absorbByKey(key);
		}
		else
		{
			throw new FrameworkError('Absorb key:$key is not fonund', FrameworkErrorCode.AbsorbNotFound);
		}
	}
	
	public function incrementVersion():Void
	{
		version++;
		if (parent != null)
		{
			parent.incrementVersion();
		}
	}
	
	public function synchronizeVersion(target:Node):Bool
	{
		return if (version != target.version)
		{
			version = target.version;
			true;
		}
		else
		{
			false;
		}
	}

	public function dispose():Void
	{
		if (disposed)
		{
			disposed = true;
			for (handler in disposeHandlers)
			{
				handler();
			}
			
			if (parent != null)
			{
				parent.children.remove(this);
			}
			children = null;
			disposeHandlers = null;
			diffusedData = null;
		}
	}
	
	public function removeFromParent():Void
	{
		if (disposed)
		{
			if (parent != null)
			{
				parent.children.remove(this);
				incrementVersion();
			}
		}
	}
	public function move(newParent:Node):Void
	{
		if (parent == newParent) return;
		removeFromParent();
		
		if (disposed)
		{
			if (newParent != null)
			{
				parent = newParent;
				newParent.children.push(this);
				incrementVersion();
			}
		}
	}
	
	public function getRoot():Node
	{
		return if (parent == null)
		{
			this;
		}
		else
		{
			parent.getRoot();
		}
	}
	
	public function addDisposeHandler(onDispose:Void->Void):Void
	{
		if (disposed)
		{
			disposeHandlers.push(onDispose);
		}
	}
	public function removeDisposeHandler(onDispose:Void->Void):Void
	{
		if (disposed)
		{
			disposeHandlers.remove(onDispose);
		}
	}
}
