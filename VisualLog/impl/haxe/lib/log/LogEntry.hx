package log;

class LogEntry
{
	public var frame(default, null):Int;
	public var clearIndex(default, null):Int;
	public var commandPosition(default, null):Int;
	public var byteSize(default, null):Int;
	
	public function new(
		frame:Int,
		clearIndex:Int,
		commandPosition:Int,
		byteSize:Int
	)
	{
		this.frame = frame;
		this.clearIndex = clearIndex;
		this.commandPosition = commandPosition;
		this.byteSize = byteSize;
	}
}
