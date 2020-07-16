package trlog;
import haxe.io.Eof;
import log.LogEntry;
import log.LogReaderBase;
import seekable.SeekableReader;

class TrlogReader extends LogReaderBase
{
	public var config(default, null):TrlogConfig;
	
	public function new(reader:SeekableReader) 
	{
		super(reader);
		var error = "";
		
		var name:UInt = reader.input.readInt32();
		if (name != (0x6F6C7274:UInt))
		{
			throw "visual log identifer must be " + (0x6F6C7274:UInt) + " but " + name;
		}
		
		var version = reader.input.readInt32();
		if (version != 1)
		{
			throw "unsupported version: " + name;
		}
		
		var headerSize = reader.input.readInt32();
		if (headerSize < 16)
		{
			throw "unsupported header size: " + headerSize;
		}
		
		config = new TrlogConfig(reader.input.readFloat());
		
		_frameSize = reader.input.readInt32(); 
		_entrySize = reader.input.readInt32(); 
		_byteSize  = reader.input.readInt32(); 
		reader.seek(headerSize - 16);
	}
	
	public function getText(frame:Int):String
	{
		var stringBuf = new StringBuf();
		prepare();
		
		for (layer in layers)
		{
			var index = layer.findEntry(frame);
			if (index <= 0) continue;
			var clearIndex = layer.entries[index - 1].clearIndex;
			for (i in clearIndex...index)
			{
				var entry = layer.entries[i];
				goto(entry.commandPosition);
				var target = position + entry.byteSize;
				while (position < target)
				{
					switch (readByte())
					{
						case TrlogCommandKind.Print:
							var string = readLongString();
							stringBuf.add(string);
							
						case command:
							throw "unknow command: " + command;
					}
				}
			}
		}
		return stringBuf.toString();
	}
}
