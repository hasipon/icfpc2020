package framework.tree;

abstract NodeId(Int) 
{
	static var maxId:Int = 0;
	public function new()
	{
		this = (maxId += 1);
	}
}