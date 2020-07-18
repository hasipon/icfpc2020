package framework.error;

class FrameworkError 
{
	private var message:String;
	private var errorCode:FrameworkErrorCode;

	public function new(message:String, errorCode:FrameworkErrorCode) 
	{
		this.errorCode = errorCode;
		this.message = message;
	}
	
	public function toString():String
	{
		return "FrameworkError: " + message + "(" + errorCode + ")";
	}
}