package seekable;
import haxe.io.Input;

interface SeekableReader 
{
	public var input(default, null):Input;
	public function seek(offset:Int):Void;
	public function close():Void;
}
