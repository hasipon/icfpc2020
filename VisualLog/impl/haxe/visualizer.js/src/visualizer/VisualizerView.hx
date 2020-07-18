package visualizer;
import js.html.Element;
import js.html.Event;
import js.html.InputElement;
import util.ElementUtil.*;
import visualizer.ctrl.VisualControlView;
import visualizer.state.VisualizerState;
import visualizer.trace.TraceView;
import visualizer.visual.VisualView;
using util.ElementUtil;

class VisualizerView
{
	private var root:Element;
	private var visualizer:Visualizer;

	private var traceLog:String;
	private var traceViews:Array<TraceView>;
	private var visualViews:Array<VisualView>;
	private var frameRange:InputElement;
	private var controlView:VisualControlView;
	
	
	public function new(
		visualizer:Visualizer, 
		root:Element,
		traceViews:Array<TraceView>,
		visualViews:Array<VisualView>
	)
	{
		this.root = root;
		this.visualizer = visualizer;
		var elements = [];
		for (node in root.childNodes)
		{
			elements.push(node);
		}
		var row, content;
		root.appendChild(
			content = div(
				{ "class": "content" },
				[
					row = div(
						{ "class": "row" },
						[
						]
					),
					div(
						{ "class": "row" },
						[
						]
					),
				]
			)
		);
		
		for (element in elements)
		{
			row.appendChild(element);
		}
		this.traceViews = traceViews;
		this.visualViews = visualViews;	
		
		this.controlView = new VisualControlView(
			visualizer,
			content
		);
	}

	public function draw():Void
	{
		switch (visualizer.state)
		{
			case VisualizerState.None | VisualizerState.Loading(_):
				controlView.stop();
				for (traceView in traceViews)
				{
					traceView.clear();
				}
				for (visualView in visualViews)
				{
					visualView.clear();
				}
				
			case VisualizerState.Display(state):
				controlView.update(state);
				for (index in 0...traceViews.length)
				{
					var traceView = traceViews[index];
					traceView.draw(state.traceReaders[index], state.maxHeight, state.step);
				}
				for (index in 0...visualViews.length)
				{
					var visualView = visualViews[index];
					visualView.draw(state.visualReaders[index], state.step);
				}
		}
	}
}
