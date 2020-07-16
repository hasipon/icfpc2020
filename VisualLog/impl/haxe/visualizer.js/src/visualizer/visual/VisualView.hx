package visualizer.visual;
import haxe.ds.Option;
import js.html.CanvasElement;
import js.html.Element;
import vilog.BlendMode;
import vilog.VilogDrawable;
import vilog.VilogReader;
import visualizer.state.VisualizerState;

class VisualView
{
	private var visualElement:Element;
	private var height:Int;
	private var width:Int;
	private var background:UInt;
	private var layerHeight:UInt;
	private var drawView:VilogDrawView;
	
	public function new(visualElement:Element) 
	{
		this.width = visualElement.scrollWidth;
		this.height = visualElement.scrollHeight;
		this.visualElement = visualElement;
		this.layerHeight = 0;
		
		background = 0xFFFFFFFF;
		
		drawView = new VilogDrawView(visualElement, width, height);
	}
	
	public function clear():Void
	{
		drawView.clear();
	}
	
	public function draw(
		reader:VilogReader,
		step:Int
	):Void
	{
		var newWidth  = reader.config.width;
		var newHeight = reader.config.height;
		drawView.draw(reader, step);
		
		if (newWidth != width || newHeight != height)
		{
			drawView.application.renderer.resize(newWidth, newHeight);
		}
		if (newWidth != width)
		{
			width = newWidth;
			drawView.application.width              = width;
			drawView.application.canvas.style.width = width + "px";
			visualElement.style.width  = width + "px";
		}
		if (newHeight != height)
		{
			height = newHeight;
			drawView.application.height              = height;
			drawView.application.canvas.style.height = height + "px";
			visualElement.style.height = height + "px";
		}
	}
}
