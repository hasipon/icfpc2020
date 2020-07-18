package visualizer.state;
import haxe.ds.Option;
import haxe.io.Bytes;
import haxe.io.BytesInput;
import js.html.ArrayBuffer;
import js.html.Element;
import js.html.ErrorEvent;
import js.html.Uint8Array;
import js.html.XMLHttpRequest;
import js.html.XMLHttpRequestResponseType;
import seekable.SeekableBytesReader;
import trlog.TrlogReader;
import vilog.VilogReader;
import visualizer.Visualizer;

class VisualizerLoadingState 
{
	private var visualizer:Visualizer;
	
	public var targets:Array<VisualizerContent>;
	public var states:Array<VisualizerSourceState>;
	
	public function new(
		visualizer:Visualizer,
		targets:Array<VisualizerContent>
	) 
	{
		this.targets = targets;
		this.visualizer = visualizer;
		states = [for (target in targets) VisualizerSourceState.Loading];
		
		for (index in 0...targets.length)
		{
			var target = targets[index];
			startLoad(target.src, target.kind, index);
		}
	}
	
	private function startLoad(source:String, kind:ContentKind, index:Int):Void
	{
		var request = new XMLHttpRequest();
		request.open("GET", source, true);
		request.responseType = XMLHttpRequestResponseType.ARRAYBUFFER;
		
		request.onload = function ()
		{
			if (request.status == 200)
			{
				var arrayBuffer:ArrayBuffer = request.response;
				var input = new BytesInput(Bytes.ofData(arrayBuffer));
				finishLoad(source, input, kind, index);
			}
			else
			{
				errorLoad(source, "Http status code " + request.status, kind, index);
			}
		};
		request.onerror = function (e:ErrorEvent)
		{
			errorLoad(source, e.message, kind, index);
		};
		request.send();
	}
	
	private function errorLoad(
		name:String,
		text:String, 
		kind:ContentKind, 
		index:Int
	):Void
	{
		states[index] = VisualizerSourceState.Error(text);
	}
	
	private function finishLoad(
		name:String,
		input:BytesInput, 
		kind:ContentKind, 
		index:Int
	):Void
	{
		states[index] = VisualizerSourceState.Loaded(input);
	}
	
	public function update():Void
	{
		var loaded = true;
		
		for (state in states)
		{
			switch (state)
			{
				case VisualizerSourceState.Error(string):
					loaded = false;
					
				case VisualizerSourceState.Loading:
					loaded = false;
					
				case VisualizerSourceState.Loaded(_):
			}
		}
		
		if (loaded)
		{
			var visualReaders = [];
			var traceReaders = [];
			
			for (index in 0...states.length)
			{
				var state = states[index];
				var target = targets[index];
				switch (state)
				{
					case VisualizerSourceState.Error(_) | VisualizerSourceState.Loading:
						
					case VisualizerSourceState.Loaded(input):
						switch (target.kind)
						{
							case ContentKind.Visual:
								var reader = new VilogReader(new SeekableBytesReader(input));
								visualReaders.push(reader);
								
							case ContentKind.Trace:
								traceReaders.push(new TrlogReader(new SeekableBytesReader(input)));
						}
				}
			}
			
			
			visualizer.state = VisualizerState.Display(
				new VisualizerDisplayState(
					visualReaders,
					traceReaders
				)
			);
		}
	}
}
