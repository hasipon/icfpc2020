package seekable;
import haxe.io.Bytes;
import haxe.io.Output;

interface SeekableWriter 
{
	public var output(default, null):Output;
	public function writeAt(offset:Int, bytes:Bytes):Void;
	public function close():Void;
}