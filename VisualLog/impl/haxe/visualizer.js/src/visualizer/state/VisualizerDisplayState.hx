package visualizer.state;
import haxe.ds.Option;
import trlog.TrlogReader;
import vilog.VilogDrawable;
import vilog.VilogReader;

class VisualizerDisplayState 
{	
	public var visualReaders(default, null):Array<VilogReader>;
	public var traceReaders(default, null):Array<TrlogReader>;
	public var playing:Bool;	
	public var fps:Float = 60; 
	public var frameSize:Int;
	public var step(get, never):Int;
	private function get_step():Int 
	{
		return Std.int(_step);
	}
	private var _step:Float;
	public var maxHeight(default, null):Int;
	
	public function new(
		visualReaders:Array<VilogReader>,
		traceReaders:Array<TrlogReader>
	) 
	{
		this.traceReaders = traceReaders;
		this.visualReaders = visualReaders;
		this._step = 0;
		this.frameSize = 0;
		this.playing = false;
		
		maxHeight = -1;
	
		for (reader in traceReaders)
		{
			fps = reader.config.fps;
			if (frameSize < reader.frameSize) 
			{
				frameSize = reader.frameSize;
			}
		}
		for (reader in visualReaders)
		{
			fps = reader.config.fps;
			if (maxHeight < reader.config.height)
			{
				maxHeight = reader.config.height;
			}
			if (frameSize < reader.frameSize) 
			{
				frameSize = reader.frameSize;
			}
		}
	}
	
	public function getTraceLog(index:Int):String
	{
		return traceReaders[index].getText(Std.int(step));
	}
	
	public function drawVisualLog(index:Int, previousStep:Int, drawTarget:VilogDrawable):Void
	{
		return visualReaders[index].draw(
			previousStep,
			Std.int(step), 
			drawTarget
		);
	}
	
	public function update(time:Float):Void
	{
		if (playing)
		{
			proceed(time / 1000 * fps);
		}
	}
	
	public function goto(step:Float):Void
	{
		_step = step;
		if (_step > frameSize - 1)
		{
			_step = frameSize - 1;
			playing = false;
		}
		else if(_step < 0)
		{
			_step = 0;
			playing = false;
		}
	}
	public function proceed(step:Float):Void
	{
		goto(_step + step);
	}
}
