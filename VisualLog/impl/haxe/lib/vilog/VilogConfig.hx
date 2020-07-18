package vilog;

class VilogConfig 
{
	public var width:Int;
	public var height:Int;
	public var fps:Float;
	public var background:Int;
	
	public function new(
		width:Int,
		height:Int,
		fps:Float = 2,
		background:Int = 0xFFFFFFFF
	)
	{
		this.width = width;
		this.height = height;
		this.fps = fps;
		this.background = background;
	}
}
