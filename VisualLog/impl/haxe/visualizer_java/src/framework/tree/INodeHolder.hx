package framework.tree;

#if !macro
@:autoBuild(framework.tree.NodeMacro.autoBuild())
#end
interface INodeHolder 
{
	public var node(default, null):Node;
}
