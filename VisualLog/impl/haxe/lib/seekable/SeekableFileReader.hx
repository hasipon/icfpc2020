package seekable;
import sys.io.FileInput;
class SeekableFileReader implements SeekableReader
{
	public var input:FileInput;
	
	public function new(input:FileInput)
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