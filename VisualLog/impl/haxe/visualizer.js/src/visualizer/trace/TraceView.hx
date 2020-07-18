package visualizer.trace;
import js.html.Element;
import trlog.TrlogReader;
import visualizer.state.VisualizerDisplayState;
import visualizer.state.VisualizerLoadingState;
import visualizer.state.VisualizerSourceState;
import visualizer.state.VisualizerState;
using util.ElementUtil;

class TraceView 
{
	private var traceArea:Element;
	private var height:Int;
	private var step:Int;
	private var traceLog:String;
	
	public function new(traceArea:Element)
	{
		this.traceArea = traceArea;	
		this.height = traceArea.scrollHeight;
		this.step = -1;
		
		traceLog = "";
	}
	
	public function clear():Void
	{
		var newTraceLog = ""; 
		step = -1;
		
		if (traceLog != newTraceLog)
		{
			traceArea.setText(newTraceLog);
			traceLog = newTraceLog;
		}
	}
	
	public function draw(
		reader:TrlogReader,
		newHeight:Int,
		newStep:Int
	):Void
	{
		if (newHeight >= 0 && newHeight != height)
		{
			height = newHeight;
			traceArea.style.height = height + "px";
		}
		
		if (newStep != step)
		{
			step = newStep;
			var newTraceLog = reader.getText(step);
			
			if (traceLog != newTraceLog)
			{
				traceArea.setText(newTraceLog);
				traceLog = newTraceLog;
			}
		}
	}
}
