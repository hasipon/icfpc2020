package interp;

abstract Reference(Int)
{
	public static var INVALID:Reference = new Reference( -1);
	
	public function new(index:Int) 
	{
		this = index;
	}
	
	public function toInt():Int
	{
		return this;
	}
	
	public function apFunc():Reference
	{
		return new Reference(this - 1);
	}
	public function apArg():Reference
	{
		var f = apFunc().toInt();
		return new Reference(f - Main.codes[f].getOffset());
	}
	
	public function get():Token
	{
		return Main.codes[this];
	}
}
