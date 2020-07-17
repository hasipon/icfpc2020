package interp;

class TypeError 
{
	public var message:String;
	public function new(message:String) 
	{
		this.message = message;
	}
	
	public function toString():String
	{
		return message;
	}
}
