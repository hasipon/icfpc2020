package vilog;

@:enum
abstract TextureRequired(Int)
{
	var No = 0;
	var Yes = 1;
	var Unknown = 2;
	
	public function new(value:Int)
	{
		if (value != 0 && value != 1 && value != 2)
		{
			throw "unsuppoted TextureRequired: " + value;
		}
		
		this = value;
	}
}
