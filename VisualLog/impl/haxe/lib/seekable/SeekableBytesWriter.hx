package seekable;
import haxe.io.Bytes;
import haxe.io.BytesOutput;
import seekable.SeekableWriter;

class SeekableBytesWriter implements SeekableWriter
{
	public var output:BytesOutput;
	
	public function new(output:BytesOutput)
	{
		this.output = output;
	}
	
	@:access(haxe.io.BytesOutput.b)
	public function writeAt(
		offset:Int,
		input:Bytes
	):Void
	{
		#if flash
		var bytesData:Bytes = Bytes.ofData(output.b);
		#else
		var bytesData:Bytes = output.b.getBytes();
		#end
		
		bytesData.blit(
			bytesData.length + offset,
			input,
			0,
			input.length
		);
	}
	
	public function close():Void
	{
	}
}
