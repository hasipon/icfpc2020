package log;
import haxe.io.BytesOutput;
import seekable.SeekableBytesWriter;
import seekable.SeekableFileWriter;
import seekable.SeekableWriter;
import sys.io.FileOutput;
import trlog.TrlogConfig;
import trlog.TrlogWriter;
import vilog.VilogConfig;
import vilog.VilogWriter;


class LogWriter
{
	private var visualWriters:Array<VilogWriter>;
	private var traceWriters:Array<TrlogWriter>;

	public function new():Void
	{
		visualWriters = [];
		traceWriters = [];
	}
	
	#if sys
	public function addVisualLogFileWriter(
		output:FileOutput, 
		config:VilogConfig
	):VilogWriter
	{
		return addVisualLogWriter(new SeekableFileWriter(output), config);
	}
	public function addTraceLogFileWriter(
		output:FileOutput, 
		?config:TrlogConfig
	):TrlogWriter
	{
		return addTraceLogWriter(new SeekableFileWriter(output), config);
	}
	#end
	
	public function addVisualLogBytesWriter(
		output:BytesOutput, 
		config:VilogConfig
	):VilogWriter
	{
		return addVisualLogWriter(new SeekableBytesWriter(output), config);
	}
	public function addTraceLogBytesWriter(
		output:BytesOutput, 
		?config:TrlogConfig
	):TrlogWriter
	{
		return addTraceLogWriter(new SeekableBytesWriter(output), config);
	}
	public function addVisualLogWriter(
		output:SeekableWriter, 
		config:VilogConfig
	):VilogWriter
	{
		var writer = new VilogWriter(output, config);
		visualWriters.push(writer);
		return writer;
	}
	public function addTraceLogWriter(
		output:SeekableWriter, 
		?config:TrlogConfig
	):TrlogWriter
	{
		var writer = new TrlogWriter(output, config);
		traceWriters.push(writer);
		return writer;
	}
	
	// ======================
	// Frame
	// ======================
	public function step():Void
	{
		for (visualWriter in visualWriters)
		{
			visualWriter.step();
		}
		for (traceWriter in traceWriters)
		{
			traceWriter.step();
		}
	}
	public function skip(frame:Int):Void
	{
		for (visualWriter in visualWriters)
		{
			visualWriter.skip(frame);
		}
		for (traceWriter in traceWriters)
		{
			traceWriter.skip(frame);
		}
	}
	
	// ======================
	// Clear
	// ======================
	public function clear():Void
	{
		for (visualWriter in visualWriters)
		{
			visualWriter.clear();
		}
		for (traceWriter in traceWriters)
		{
			traceWriter.clear();
		}
	}
	
	// ======================
	// Finish
	// ======================
	public function finish():Void
	{
		for (visualWriter in visualWriters)
		{
			visualWriter.finish();
		}
		for (traceWriter in traceWriters)
		{
			traceWriter.finish();
		}
	}
}
