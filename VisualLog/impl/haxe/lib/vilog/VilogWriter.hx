package vilog;
import log.LogWriter;
import log.LogWriterBase;
import seekable.SeekableWriter;
import haxe.io.Bytes;
import haxe.io.BytesOutput;
import haxe.io.Output;
import seekable.SeekableBytesWriter;

#if sys
import sys.io.FileOutput;
import seekable.SeekableFileWriter;
#end

class VilogWriter extends LogWriterBase implements IVilogWriter
{
	public var textureRequired(default, null):Bool;
	
	public function new(writer:SeekableWriter, config:VilogConfig) 
	{
		super(writer);
		
		writer.output.writeString("vilo");
		writer.output.writeInt32(1);                 // version
		writer.output.writeInt32(29);                // header size
		writer.output.writeInt32(config.width);
		writer.output.writeInt32(config.height);
		writer.output.writeFloat(config.fps);
		writer.output.writeInt32(config.background);
		writer.output.writeByte(2); 
		writer.output.writeInt32(0xFFFFFFFF); 
		writer.output.writeInt32(0xFFFFFFFF); 
		writer.output.writeInt32(0xFFFFFFFF); 
	}
	
	#if sys
	public static function fromFileOutput(output:FileOutput, config:VilogConfig):VilogWriter
	{
		return new VilogWriter(
			new SeekableFileWriter(output),
			config
		);
	}
	#end
	
	public function addLayer():VilogLayerWriter
	{
		prepare();
		var layer = new VilogLayerWriter(this, layers.length);
		layers.push(layer);
		return layer;
	}
	
	// ======================
	// Finish
	// ======================
	public function finish():Void
	{
		prepare();
		
		var localOutput = new BytesOutput();
		localOutput.bigEndian = false;
		
		localOutput.writeByte(if (textureRequired) 1 else 0);
		localOutput.writeInt32(frameSize);
		localOutput.writeInt32(keyFrameSize);
		localOutput.writeInt32(frameByteSize);
		
		writer.writeAt(
			-frameByteSize - 13,
			localOutput.getBytes()
		);
		
		writer.close();
	}
}

