package sort;
import log.LogWriter;
import sys.io.File;
import trlog.TrlogLayerWriter;
import trlog.TrlogWriter;
import vilog.VilogLayerWriter;
import vilog.VilogConfig;
import vilog.VilogWriter;

class ArrayWithBufferWriter extends LogWriter
{
	public static var WIDTH:Int = 640;
	public static var HEIGHT:Int = 360;
	public static var MARGIN:Int = 2;
	
	public static var OUTPUT_DIRECTORY:String = "../../../../sample";
	
	public var vilogWriter(default, null):VilogWriter;
	private var trlogWriter(default, null):TrlogWriter;
	
	public var backgroundLayer(default, null):VilogLayerWriter;
	public var contentLayer(default, null):VilogLayerWriter;
	
	public var foregroundLayer(default, null):VilogLayerWriter;
	public var arrowLayer(default, null):VilogLayerWriter;
	
	public var commentLayer(default, null):TrlogLayerWriter;
	
	public function new(name:String)
	{
		super();
		vilogWriter = addVisualLogFileWriter(
			File.write(OUTPUT_DIRECTORY + "/" + name + ".vilog"),
			new VilogConfig(WIDTH, HEIGHT)
		);
		trlogWriter = addTraceLogFileWriter(
			File.write(OUTPUT_DIRECTORY + "/" + name + ".trlog")
		);
		
		backgroundLayer = vilogWriter.addLayer();
		contentLayer = vilogWriter.addLayer();
		foregroundLayer = vilogWriter.addLayer();
		arrowLayer = vilogWriter.addLayer();
		commentLayer = trlogWriter.addLayer();
	}

	public function drawBackground(size:Int):Void
	{
		backgroundLayer.clear();
		backgroundLayer.setLineAlpha(1);
		backgroundLayer.setLineColor(0xFFFFFF);
		backgroundLayer.setFillAlpha(1);
		backgroundLayer.setFillColor(0xFDFDFD);
		backgroundLayer.setLineThickness(MARGIN);
		
		backgroundLayer.drawGrid(
			MARGIN / 2,
			MARGIN / 2,
			size,
			2,
			(WIDTH - MARGIN) / size,
			(HEIGHT - MARGIN) / 2
		);
	}
	
	public function drawArray(
		array:Array<Int>, 
		buffer:Array<Int>
	) 
	{
		contentLayer.clear();
		contentLayer.setLineAlpha(0);
		contentLayer.setFillAlpha(1);
		contentLayer.setFillColor(0xFF9696);
		
		var width = (WIDTH - MARGIN) / array.length - MARGIN;
		var height = (HEIGHT - MARGIN) / 2 - MARGIN;
		_draw(
			array,
			array.length,
			MARGIN,
			height
		);
		_draw(
			buffer,
			array.length,
			MARGIN * 2 + height,
			height
		);
		step();
	}
	
	private function _draw(
		data:Array<Int>,
		size:Int,
		y:Float,
		height:Float
	):Void
	{	
		var width = (WIDTH - MARGIN) / size - MARGIN;
		contentLayer.drawColumns(
			MARGIN,
			y + height,
			width,
			MARGIN,
			[for (i in data) (i:Float)],
			height / size
		);
	}
	public function drawMove(
		value:Float,
		aIsBuffer:Bool, aIndex:Int, 
		bIsBuffer:Bool, bIndex:Int,
		size:Int
	) 
	{
		foregroundLayer.setLineAlpha(0);
		foregroundLayer.setFillAlpha(1);
		foregroundLayer.setFillColor(0xFF0000);
	
		arrowLayer.setLineThickness(2);
		arrowLayer.setLineAlpha(1);
		arrowLayer.setFillAlpha(0);
		arrowLayer.setLineColor(0x7755EE);
		
		var margin = MARGIN;
		var width = (WIDTH - margin) / size - margin;
		var height = (HEIGHT - margin) / 2 - margin;
		
		var x = margin + (width + margin) * aIndex;
		var y = -value / size * height + if (aIsBuffer) HEIGHT - margin else margin + height;
		var valueHeight = value / size * height;
		arrowLayer.moveTo(x + width / 2, y + valueHeight / 2);
		
		var x = margin + (width + margin) * bIndex;
		var y = - value / size * height + if (bIsBuffer) HEIGHT - margin else margin + height;
		var valueHeight = value / size * height;
		foregroundLayer.drawRectangle(x, y, width, valueHeight);
		arrowLayer.arrowTo(x + width / 2, y + valueHeight / 2, false, true, true, 12, 8);
		
	}
	public function drawCompare(
		aValue:Float,
		aIsBuffer:Bool, aIndex:Int, 
		bValue:Float,
		bIsBuffer:Bool, bIndex:Int,
		size:Int
	) 
	{
		foregroundLayer.setLineAlpha(0);
		foregroundLayer.setFillAlpha(1);
		foregroundLayer.setFillColor(0xFFAA00);
		
		arrowLayer.setLineThickness(2);
		arrowLayer.setLineAlpha(1);
		arrowLayer.setFillAlpha(0);
		arrowLayer.setLineColor(0x44EEFF);
		
		var margin = MARGIN;
		var width = (WIDTH - margin) / size - margin;
		var height = (HEIGHT - margin) / 2 - margin;
		
		var x = margin + (width + margin) * aIndex;
		var y = -aValue / size * height + if (aIsBuffer) HEIGHT - margin else margin + height;
		var valueHeight = aValue / size * height;
		foregroundLayer.drawRectangle(x, y, width, valueHeight);
		var sx = x + width / 2;
		var sy = y + valueHeight / 2;
		arrowLayer.moveTo(sx, sy);
		
		var x = margin + (width + margin) * bIndex;
		var y = - bValue / size * height + if (bIsBuffer) HEIGHT - margin else margin + height;
		var valueHeight = bValue / size * height;
		foregroundLayer.drawRectangle(x, y, width, valueHeight);
		var aIsLarge = aValue > bValue;
		var ex = x + width / 2;
		var ey = y + valueHeight / 2;
		var dx = ex - sx;
		var dy = ey - sy;
		var len = Math.sqrt(dx * dx + dy * dy);
		arrowLayer.arrowTo(ex, ey, !aIsLarge, false, aIsLarge, 18, len);
	}

	public function printLine(string:String):Void
	{
		commentLayer.clear();
		commentLayer.printLine(string);
	}

	public function clearForeground() 
	{
		foregroundLayer.clear();
		arrowLayer.clear();
	}
}
