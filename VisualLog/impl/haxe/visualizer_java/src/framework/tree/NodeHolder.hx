package framework.tree;
import framework.tree.Node;

#if macro
import haxe.macro.Context;
import haxe.macro.Expr;
import haxe.macro.ExprTools;
import haxe.macro.TypeTools;
#end

class NodeHolder implements INodeHolder
{
	public var node(default, null):Node;
	
	public function new(parent:INodeHolder) 
	{
		node = new Node(if (parent == null) null else parent.node);
	}
	
	private macro function diffuse(self:Expr, type:Expr):Expr
	{
		var key = TypeTools.toString(Context.getType(ExprTools.toString(type)));
		return macro $self.node.diffuseByKey(this, $v{key});
	}
}
