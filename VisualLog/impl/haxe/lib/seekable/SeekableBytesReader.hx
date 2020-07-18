package seekable;
import haxe.io.BytesInput;

class SeekableBytesReader implements SeekableReader
{
	public var input:BytesInput;
	
	public function new(input:BytesInput)
	{
		this.input = input;
	}
	
	public function seek(offset:Int):Void
	{
		input.position += offset;
	}
	
	public function close():Void
	{
	}
}