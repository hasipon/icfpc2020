package visualizer.visual;
import haxe.ds.Map;
import js.html.CanvasElement;
import js.html.Element;
import pixi.core.graphics.Graphics;
import pixi.plugins.app.Application;
import vilog.VilogLayerDrawable;
import vilog.VilogDrawable;
import vilog.VilogReader;

class VilogDrawView implements VilogDrawable
{
	private var previousReader:VilogReader;
	private var previousStep:Int;
	
	private var depthToIndex:Map<Int, Int>;
	private var layers:Array<VilogLayerDrawView>;
	private var background:Graphics;
	private var previousBackground:Int;
	
	public var application:Application;
	
	public function new(
		visualElement:Element,
		width:Int,
		height:Int
	) 
	{
		application = new Application();
		application.width = width;
		application.height = height;
		application.position = "relative";
		application.autoResize = false;
		application.antialias = true;
		application.start("", visualElement, null);
		
		background = new Graphics();
		application.stage.addChild(background);
		previousBackground = 0;
		
		init();
	}
	
	public function clear():Void
	{
		if (previousReader != null)
		{
			init();
		}
	}
	
	private function init():Void
	{
		previousStep = -1;
		previousReader = null;
		if (layers != null)
		{
			for (layer in layers)
			{
				layer.clear();
			}
		}
		layers = null;
		depthToIndex = null;
		drawBackground(0xFFFFFFFF);
	}
	
	public function draw(
		reader:VilogReader,
		step:Int
	):Void
	{
		if (previousReader != reader)
		{
			if (reader != null)
			{
				reader.prepare();
				depthToIndex = new Map();
				layers = [];
				
				var index = 0;
				for (readerLayer in reader.layers)
				{
					depthToIndex[readerLayer.layerDepth] = index;
					layers.push(new VilogLayerDrawView(application.stage));
					index += 1;
				}
				
				drawBackground(reader.config.background);
			}
			previousReader = reader;
		}
		if (previousStep != step)
		{
			reader.draw(previousStep, step, this);
			previousStep = step;
		}
	}
	
	public function drawBackground(argb:UInt):Void
	{
		if (previousBackground != argb)
		{
			background.clear();
			
			var rgb = argb & 0xFFFFFF;
			var alphaChannel = argb >>> 24 & 0xFF;
			
			if (alphaChannel != 0xFF)
			{
				application.transparent = true;
				application.backgroundColor = rgb; 
			}
			else
			{
				background.beginFill(rgb, alphaChannel / 0xFF);
				background.drawRect(
					0, 0, 
					application.width, application.height
				);
				background.endFill();
			}
			
			previousBackground = argb;
		}
	}
	
	public function getLayer(layerDepth:Int):VilogLayerDrawable
	{
		return layers[depthToIndex[layerDepth]];
	}
}
