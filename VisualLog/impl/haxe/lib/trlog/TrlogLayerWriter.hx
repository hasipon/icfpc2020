package trlog;
import haxe.PosInfos;
import haxe.io.Bytes;
import log.LogLayerWriterBase;

class TrlogLayerWriter extends LogLayerWriterBase
{
	public function new(
		parent:TrlogWriter,
		layerDepth:Int
	) 
	{
		super(parent, layerDepth);
	}
	
	// ======================
	// Command
	// ======================
	public function print(string:String):Void
	{
		bytesBuffer.writeByte(TrlogCommandKind.Print);
		
		var bytes = Bytes.ofString(string);
		bytesBuffer.writeUInt24(bytes.length);
		bytesBuffer.write(bytes);
	}
	public function printLine(string:String):Void
	{
		print(string + "\n");
	}
	public function trace(string:String, ?pos:PosInfos):Void
	{
		printLine(pos.fileName + ":" + pos.lineNumber + ": " + string);
	}
}
