package visualizer;
import js.html.Element;
import visualizer.state.VisualizerContent;
import visualizer.state.VisualizerDisplayState;
import visualizer.state.VisualizerLoadingState;
import visualizer.state.VisualizerState;
import visualizer.trace.TraceView;
import visualizer.visual.VisualView;

class Visualizer 
{
	private var view:VisualizerView;
	private var element:Element;
	public var state:VisualizerState;
	
	public function new(element:Element)
	{
		this.element = element;
	
		var traceViews = [];
		var visualViews = [];
		
		var targets = [];
		for (child in element.getElementsByClassName("visual"))
		{
			var src = child.getAttribute("src");
			if (src != null)
			{
				targets.push(new VisualizerContent(child, src, ContentKind.Visual));
				visualViews.push(new VisualView(child));
			}
		}
		for (child in element.getElementsByClassName("trace"))
		{
			var src = child.getAttribute("src");
			if (src != null)
			{
				targets.push(new VisualizerContent(child, src, ContentKind.Trace));
				traceViews.push(new TraceView(child));
			}
		}

		view = new VisualizerView(
			this, 
			element,
			traceViews,
			visualViews
		);
		state = VisualizerState.Loading(
			new VisualizerLoadingState(
				this,
				targets
			)
		);
	}

	public function update(time:Float):Void
	{
		switch (state)
		{
			case VisualizerState.None:
				
			case VisualizerState.Loading(state):
				state.update();
				
			case VisualizerState.Display(state):
				state.update(time);
		}
		
		view.draw();
	}
}

