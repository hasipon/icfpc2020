package seekable;
import haxe.io.Bytes;
import seekable.SeekableWriter;

#if sys
import sys.io.FileOutput;
import sys.io.FileSeek;

class SeekableFileWriter implements SeekableWriter
{
	public var output(default, null):FileOutput;
	
	public function new(output:FileOutput)
	{
		this.output = output;
	}
	
	public function writeAt(
		offset:Int,
		bytes:Bytes
	):Void
	{
		output.seek(offset, FileSeek.SeekCur);
		output.write(bytes);
		output.seek(-offset - bytes.length, FileSeek.SeekCur);
	}

	public function close():Void
	{
		output.close();
	}
}
#end
