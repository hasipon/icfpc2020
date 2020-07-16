package log;
import haxe.ds.Map;
import haxe.io.Eof;
import log.LogEntry;
import log.LogEntry;
import log.LogReaderLayer;
import seekable.SeekableReader;

class LogReaderBase 
{
	private var reader:SeekableReader;
	private var position:Int;
	
	private var _byteSize:UInt;
	private var _entrySize:Int;
	private var _frameSize:Int;
	
	public var byteSize(get, never):UInt;
	private function get_byteSize():UInt 
	{
		prepare();
		return _byteSize;
	}
	public var entrySize(get, never):UInt;
	private function get_entrySize():UInt 
	{
		prepare();
		return _entrySize;
	}
	public var frameSize(get, never):UInt;
	private function get_frameSize():UInt 
	{
		prepare();
		return _frameSize;
	}
	
	public var layers(default, null):Array<LogReaderLayer>;
	
	public function new(reader:SeekableReader) 
	{
		this.reader = reader;
		reader.input.bigEndian = false;
		
		position = 0;
	}
	
	private function readInt32():Int
	{
		var value = reader.input.readInt32();
		this.position += 4;
		return value;
	}
	private function readFloat():Float
	{
		var value = reader.input.readFloat();
		this.position += 4;
		return value;
	}
	private function readAlpha():Float
	{
		return readUInt16() / 65535;
	}
	private function readRotation(points:UInt):Float
	{
		var max = Math.PI * 2 / points;
		return readUInt16() / 65535 * max;
	}
	private function readUInt24():Int
	{
		var value = reader.input.readUInt24();
		this.position += 3;
		return value;
	}
	private function readUInt16():Int
	{
		var value = reader.input.readUInt16();
		this.position += 2;
		return value;
	}
	private function readByte():Int
	{
		var value = reader.input.readByte();
		this.position += 1;
		return value;
	}
	private function readShortString():String
	{
		var size:UInt = readUInt16();
		var value = reader.input.read(size);
		this.position += size;
		return value.toString();
	}
	private function readLongString():String
	{
		var size:UInt = readUInt24();
		var value = reader.input.read(size);
		this.position += size;
		return value.toString();
	}
	private function readArrayString():Array<String>
	{
		var size:UInt = readUInt16();
		return [for (i in 0...size) readShortString()];
	}
	private function readArrayFloat():Array<Float>
	{
		var size:UInt = readUInt16();
		return [for (i in 0...size) readFloat()];
	}
	private function readBool():Bool
	{
		return switch (readByte())
		{
			case 0: false;
			case 1: true;
			case value: throw "unknown bool: " + value;
		}
	}
	private function skip(data:Int):Void
	{
		goto(position + data);
	}
	
	private function goto(position:Int):Void
	{
		reader.seek(position - this.position);
		this.position = position;
	}
	
	@:access(log.LogReaderLayer)
	public function prepare():Void
	{
		if (layers == null)
		{
			_entrySize = 0;
			var frame = 0;
			var layerMap = new Map();
			var layerIndexes = [];
			
			goto(0);
			while (true)
			{
				var layerNumber, clear, commandPosition, byteSize;
				try 
				{
					frame += readInt32();
					layerNumber = readInt32();
					var flags = readByte();
					clear = (flags % 2 == 1);
					byteSize = readInt32();
					commandPosition = position;
					skip(byteSize);
				}
				catch (e:Eof)
				{
					break;
				}
				var layer = if (layerMap.exists(layerNumber))
				{
					layerMap[layerNumber];
				}
				else
				{
					layerIndexes.push(layerNumber);
					layerMap[layerNumber] = new LogReaderLayer(layerNumber);
				}
				if (clear)
				{
					layer.clearIndex = layer.entries.length;
				}
				layer.entries.push(
					new LogEntry(
						frame,
						layer.clearIndex,
						commandPosition,
						byteSize
					)
				);
				_entrySize += 1;
			}
			
			layerIndexes.sort(compareInt);
			layers = [for (i in layerIndexes) layerMap[i]];
			
			_byteSize = position;
			_frameSize = frame + 1;
		}
	}

	private static function compareInt(a:Int, b:Int):Int 
	{
		if (a < b) return -1;
		else if (a > b) return 1;
		return 0;
	}
}
