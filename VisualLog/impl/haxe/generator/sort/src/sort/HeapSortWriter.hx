package sort;
import log.LogWriter;
import sys.io.File;
import trlog.TrlogLayerWriter;
import trlog.TrlogWriter;
import vilog.VilogLayerWriter;
import vilog.VilogConfig;
import vilog.VilogWriter;

class HeapSortWriter extends LogWriter
{
	public static var WIDTH:Int          = 640;
	public static var CONTENT_HEIGHT:Int = 240;
	public static var HEIGHT:Int         = 360;
	public static var MARGIN:Int         = 2;
	
	public static var OUTPUT_DIRECTORY:String = "../../../../sample";
	
	public var vilogWriter(default, null):VilogWriter;
	private var trlogWriter(default, null):TrlogWriter;
	
	public var backgroundLayer(default, null):VilogLayerWriter;
	public var heapLayer(default, null):VilogLayerWriter;
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
		heapLayer = vilogWriter.addLayer();
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
			1,
			(WIDTH - MARGIN) / size,
			CONTENT_HEIGHT + MARGIN
		);
	}
	private static var colors = [
		0xFF5588,
		0x88FF55,
		0x5588FF,
		0xFF22DD,
		0xDDEE11,
		0x22DDFF,
		0xCCBBCC,
		0x7722FF,
		0xFF7722,
		0x22FF77,
	];
	public function drawHeap(index:Int, size:Int):Void
	{
		heapLayer.clear();
		heapLayer.setLineAlpha(0.3);
		heapLayer.setFillAlpha(0);
		heapLayer.setLineThickness(MARGIN);
		var width = (WIDTH - MARGIN) / size - MARGIN;
		
		for (i in 1...index + 1)
		{
			var target = ((i + 1) >> 1) - 1;
			heapLayer.setLineColor(colors[target % colors.length]);
			var baseY = CONTENT_HEIGHT + MARGIN;
			var sx = i * (MARGIN + width) + MARGIN + width / 2;
			heapLayer.moveTo(
				sx,
				baseY
			);
			var ex = target * (MARGIN + width) + MARGIN + width / 2;
			var scale = 0;
			var value = target + 1;
			while (value > 0) {
				scale += 1;
				value = value >> 1;
			}
			heapLayer.quaraticCurveTo(
				(sx + ex) / 2,
				baseY + 30 * scale,
				ex,
				baseY
			);
		}
	}
	public function drawArray(array:Array<Int>) 
	{
		contentLayer.clear();
		contentLayer.setLineAlpha(0);
		contentLayer.setFillAlpha(1);
		contentLayer.setFillColor(0xFF9696);
		
		var size = array.length;
		var width = (WIDTH - MARGIN) / size - MARGIN;
		contentLayer.drawColumns(
			MARGIN,
			MARGIN + CONTENT_HEIGHT,
			width,
			MARGIN,
			[for (i in array) (i:Float)],
			CONTENT_HEIGHT / size
		);
		step();
	}
	
	public function drawSwap(data:Array<Int>, aIndex:Int, bIndex:Int, inHeap:Bool) 
	{
		foregroundLayer.setLineAlpha(0);
		foregroundLayer.setFillAlpha(1);
		foregroundLayer.setFillColor(0xFF0000);
	
		arrowLayer.setLineThickness(2);
		arrowLayer.setLineAlpha(1);
		arrowLayer.setFillAlpha(0);
		arrowLayer.setLineColor(0x7755EE);
		
		var size = data.length;
		var margin = MARGIN;
		var width = (WIDTH - margin) / size - margin;
		var height = CONTENT_HEIGHT;
		
		var aValue = data[aIndex];
		var x = margin + (width + margin) * aIndex;
		var y = -aValue / size * height + margin + height;
		var valueHeight = aValue / size * height;
		foregroundLayer.drawRectangle(x, y, width, valueHeight);
		arrowLayer.moveTo(x + width / 2, y + valueHeight / 2);
		
		var bValue = data[bIndex];
		var x = margin + (width + margin) * bIndex;
		var y = - bValue / size * height + margin + height;
		var valueHeight = bValue / size * height;
		foregroundLayer.drawRectangle(x, y, width, valueHeight);
		arrowLayer.arrowTo(x + width / 2, y + valueHeight / 2, true, true, true, 12, 8);
		if (inHeap) drawHeapLine(aIndex, bIndex, size);
	}
	public function drawCompare(data:Array<Int>, aIndex:Int, bIndex:Int, inHeap:Bool) 
	{
		foregroundLayer.setLineAlpha(0);
		foregroundLayer.setFillAlpha(1);
		foregroundLayer.setFillColor(0xFFAA00);
		
		arrowLayer.setLineThickness(2);
		arrowLayer.setLineAlpha(1);
		arrowLayer.setFillAlpha(0);
		arrowLayer.setLineColor(0x44EEFF);
		
		var size = data.length;
		var margin = MARGIN;
		var width = (WIDTH - margin) / size - margin;
		var height = CONTENT_HEIGHT;
		
		var aValue = data[aIndex];
		var x = margin + (width + margin) * aIndex;
		var y = -aValue / size * height + margin + height;
		var valueHeight = aValue / size * height;
		foregroundLayer.drawRectangle(x, y, width, valueHeight);
		var sx = x + width / 2;
		var sy = y + valueHeight / 2;
		arrowLayer.moveTo(sx, sy);
		
		var bValue = data[bIndex];
		var x = margin + (width + margin) * bIndex;
		var y = - bValue / size * height + margin + height;
		var valueHeight = bValue / size * height;
		foregroundLayer.drawRectangle(x, y, width, valueHeight);
		var aIsLarge = aValue > bValue;
		var ex = x + width / 2;
		var ey = y + valueHeight / 2;
		var dx = ex - sx;
		var dy = ey - sy;
		var len = Math.sqrt(dx * dx + dy * dy);
		arrowLayer.arrowTo(ex, ey, !aIsLarge, false, aIsLarge, 18, len);
		if (inHeap) 
		{
			drawHeapLine(aIndex, bIndex, size);
		}
		else
		{
			var target = ((aIndex + 1) >> 1) - 1;
			drawHeapLine(target, aIndex, size);
			drawHeapLine(target, bIndex, size);
		}
		step();
	}
	private function drawHeapLine(aIndex:Int, bIndex:Int, size:Int):Void
	{
		var width = (WIDTH - MARGIN) / size - MARGIN;
		arrowLayer.setLineColor(colors[aIndex % colors.length]);
		var baseY = CONTENT_HEIGHT + MARGIN;
		var sx = bIndex * (MARGIN + width) + MARGIN + width / 2;
		arrowLayer.moveTo(
			sx,
			baseY
		);
		var ex = aIndex * (MARGIN + width) + MARGIN + width / 2;
		var scale = 0;
		var value = aIndex + 1;
		while (value > 0) {
			scale += 1;
			value = value >> 1;
		}
		arrowLayer.quaraticCurveTo(
			(sx + ex) / 2,
			baseY + 30 * scale,
			ex,
			baseY
		);
	}
	public function clearForeground() 
	{
		foregroundLayer.clear();
		arrowLayer.clear();
	}
	
	public function printLine(string:String):Void
	{
		commentLayer.clear();
		commentLayer.printLine(string);
	}
}
