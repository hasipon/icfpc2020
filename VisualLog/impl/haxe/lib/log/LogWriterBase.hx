package log;
import haxe.io.BytesOutput;
import seekable.SeekableWriter;

@:access(log.LogLayerWriterBase)
class LogWriterBase
{
	public var writer(default, null):SeekableWriter;
	
	public var frameSize(default, null):UInt;
	public var keyFrameSize(default, null):UInt;
	public var frameByteSize(default, null):UInt;
	
	private var skipCount(default, null):UInt;
	
	private var layer(default, null):UInt;
	private var previousLayer(default, null):UInt;
	
	private var layers(default, null):Array<LogLayerWriterBase>;
	
	public function new(writer:SeekableWriter) 
	{
		this.writer = writer;
		writer.output.bigEndian = false;
		
		frameSize = 0;
		keyFrameSize = 0;
		frameByteSize = 0;
		skipCount = 0;
		
		layers = [];
	}

	// ======================
	// Frame
	// ======================
	public function step():Void
	{
		skip(1);
	}
	public function skip(frame:Int):Void
	{
		prepare();
		skipCount += frame;
		frameSize += frame;
	}
	
	// ======================
	// Prepare
	// ======================
	private function prepare():Void
	{
		for (layer in layers)
		{
			layer.prepare();
		}
	}
	
	// ======================
	// Clear
	// ======================
	public function clear():Void
	{
		for (layer in layers)
		{
			layer.clear();
		}
	}
}
