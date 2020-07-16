package log;
import haxe.io.BytesOutput;
import seekable.SeekableWriter;

@:access(log.LogWriterBase)
class LogLayerWriterBase 
{
	private var parent:LogWriterBase;
	private var layerDepth:Int;
	
	public var bytesBuffer(default, null):BytesOutput;
	private var shouldClear:Bool;
	
	public function new(
		parent:LogWriterBase,
		layerDepth:Int
	) 
	{
		this.layerDepth = layerDepth;
		this.parent = parent;
		this.shouldClear = false;
		bytesBuffer = new BytesOutput();
		bytesBuffer.bigEndian = false;
	}
	
	public function clear():Void
	{
		prepare();
		shouldClear = true;
	}
	
	private function prepare():Void
	{
		var bytesLength = bytesBuffer.length;
		if (bytesLength > 0 || shouldClear)
		{
			parent.writer.output.writeInt32(parent.skipCount);
			parent.writer.output.writeInt32(layerDepth);
			parent.writer.output.writeByte(if (shouldClear) 1 else 0);
			parent.writer.output.writeInt32(bytesLength);
			parent.writer.output.write(bytesBuffer.getBytes());
			
			shouldClear = false;
			parent.skipCount = 0;
			parent.keyFrameSize += 1;
			parent.frameByteSize += bytesLength + 13;
			
			bytesBuffer = new BytesOutput();
			bytesBuffer.bigEndian = false;
		}
	}
}
