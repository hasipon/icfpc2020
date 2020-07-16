package log;

class LogReaderLayer 
{
	public var layerDepth(default, null):Int;
	public var entries(default, null):Array<LogEntry>;
	private var clearIndex:Int;
	
	public function new(layerDepth:Int) 
	{
		this.layerDepth = layerDepth;
		clearIndex = 0;
		entries = [];
	}

	public function findEntry(frame:Int):Int
    {
	    var min = 0;
        var max = entries.length;
		while (true) 
		{
			var next = Std.int((max - min) / 2) + min;
			var dv = entries[next].frame;
			if (dv <= frame) {
				min = next + 1;
			} else {
				max = next;
			}
			if (min == max) break;
		}
        return min;
    }
}