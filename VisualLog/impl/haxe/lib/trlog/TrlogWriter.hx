package trlog;
import haxe.io.BytesOutput;
import log.LogWriterBase;
import seekable.SeekableWriter;
import trlog.TrlogConfig;

#if sys
import seekable.SeekableFileWriter;
import sys.io.FileOutput;
#end

class TrlogWriter extends LogWriterBase implements ITrlogWriter
{	
	public function new(writer:SeekableWriter, ?config:TrlogConfig) 
	{
		super(writer);
		if (config == null)
		{
			config = new TrlogConfig();
		}
		
		writer.output.writeString("trlo");
		writer.output.writeInt32(1);                 // version
		writer.output.writeInt32(16);                // header size
		writer.output.writeFloat(config.fps);
		writer.output.writeInt32(0xFFFFFFFF); 
		writer.output.writeInt32(0xFFFFFFFF); 
		writer.output.writeInt32(0xFFFFFFFF); 
	}
	
	#if sys
	public static function fromFileOutput(output:FileOutput, config:TrlogConfig):TrlogWriter
	{
		return new TrlogWriter(
			new SeekableFileWriter(output),
			config
		);
	}
	#end
	
	// ======================
	// Layer
	// ======================
	public function addLayer():TrlogLayerWriter
	{
		prepare();
		var layer = new TrlogLayerWriter(this, layers.length);
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
		
		localOutput.writeInt32(frameSize);
		localOutput.writeInt32(keyFrameSize);
		localOutput.writeInt32(frameByteSize);
		
		writer.writeAt(
			-frameByteSize - 12,
			localOutput.getBytes()
		);
		writer.close();
	}
}