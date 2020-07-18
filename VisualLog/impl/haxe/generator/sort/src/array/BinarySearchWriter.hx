package array;
import log.LogWriter;
import sys.io.File;
import trlog.TrlogLayerWriter;
import trlog.TrlogWriter;
import vilog.VilogConfig;
import vilog.VilogLayerWriter;
import vilog.VilogWriter;

class BinarySearchWriter extends LogWriter
{
	public static inline var CELL_SIZE:Int = 25;
	public static inline var CELL_MARGIN:Int = 2;
	public static inline var MARGIN:Int = 20;
	public static inline var WIDTH:Int  = MARGIN * 2 + CELL_SIZE * BinarySearch.SIZE;
	public static inline var HEIGHT:Int = MARGIN * 2 + CELL_SIZE * 2;
	
	public static var OUTPUT_DIRECTORY:String = "../../../../sample";
	
	public var vilogWriter(default, null):VilogWriter;
	private var trlogWriter(default, null):TrlogWriter;
	
	public var contentLayer(default, null):VilogLayerWriter;
	public var minMaxLayer(default, null):VilogLayerWriter;
	public var cursorLayer(default, null):VilogLayerWriter;
	
	public var commentLayer(default, null):TrlogLayerWriter;
	
	public function new(name:String)
	{
		super();
		vilogWriter = addVisualLogFileWriter(
			File.write(OUTPUT_DIRECTORY + "/" + name + ".vilog"),
			new VilogConfig(WIDTH, HEIGHT, 2)
		);
		trlogWriter = addTraceLogFileWriter(
			File.write(OUTPUT_DIRECTORY + "/" + name + ".trlog")
		);
		
		contentLayer = vilogWriter.addLayer();
		minMaxLayer = vilogWriter.addLayer();
		cursorLayer = vilogWriter.addLayer();
	}
	
	public function drawArray(array:Array<Bool>):Void
	{
		contentLayer.setFillAlpha(1);
		contentLayer.setFillColor(0xFAFAFA);
		contentLayer.setLineAlpha(1);
		contentLayer.setLineColor(0xFDFDFD);
		for (i in 0...array.length) {
			if (array[i]) {
				contentLayer.setFillColor(0xFFAA00);
			}
			contentLayer.drawRoundedRectangle(
				CELL_SIZE * i + CELL_MARGIN + MARGIN,
				CELL_MARGIN + MARGIN,
				CELL_SIZE - CELL_MARGIN * 2,
				CELL_SIZE - CELL_MARGIN * 2,
				2
			);
		}
		
		contentLayer.setLineAlpha(1);
		contentLayer.setLineColor(0xDDDDDD);
		contentLayer.setFillAlpha(0);
		contentLayer.drawGrid(
			MARGIN,
			MARGIN,
			array.length,
			1,
			CELL_SIZE,
			CELL_SIZE
		);
	}
	
	public function drawMinMax(min:Int, max:Int, highlightMin:Bool, highlightMax:Bool):Void
	{
		minMaxLayer.clear();
		minMaxLayer.setLineAlpha(1);
		minMaxLayer.setFillAlpha(0);
		minMaxLayer.setLineThickness(2);
		minMaxLayer.setTextHolizontalAlign(0.5);
		minMaxLayer.setFontStyle(true, false);
		
		if (min == max)
		{
			var color = 0xFF8800;
			minMaxLayer.setLineColor(color);
			minMaxLayer.moveTo(
				MARGIN + CELL_SIZE * min,
				MARGIN + CELL_SIZE * 1.5
			);
			minMaxLayer.arrowTo(
				MARGIN + CELL_SIZE * min,
				MARGIN + CELL_SIZE,
				false,
				true,
				true,
				8,
				5
			);
			minMaxLayer.setFillAlpha(1);
			minMaxLayer.setFillColor(color);
			minMaxLayer.drawText(
				MARGIN + CELL_SIZE * min,
				MARGIN + CELL_SIZE * 1.5,
				"ANSWER!"
			);
		}
		else
		{
			
			var color = if (highlightMin) 0x6666FF else 0x888888;
			minMaxLayer.setLineColor(color);
			minMaxLayer.moveTo(
				MARGIN + CELL_SIZE * min,
				MARGIN + CELL_SIZE * 1.5
			);
			minMaxLayer.arrowTo(
				MARGIN + CELL_SIZE * min,
				MARGIN + CELL_SIZE,
				false,
				true,
				true,
				8,
				5
			);
			
			var color = if (highlightMax) 0xFF3333 else 0x888888;
			minMaxLayer.setLineColor(color);
			minMaxLayer.moveTo(
				MARGIN + CELL_SIZE * max,
				MARGIN + CELL_SIZE * 1.5
			);
			minMaxLayer.arrowTo(
				MARGIN + CELL_SIZE * max,
				MARGIN + CELL_SIZE,
				false,
				true,
				true,
				8,
				5
			);
		
			minMaxLayer.setFillAlpha(1);
			var color = if (highlightMin) 0x6666FF else 0x888888;
			minMaxLayer.setFillColor(color);
			minMaxLayer.drawText(
				MARGIN + CELL_SIZE * min,
				MARGIN + CELL_SIZE * 1.5,
				"MIN"
			);
			var color = if (highlightMax) 0xFF3333 else 0x888888;
			minMaxLayer.setFillColor(color);
			minMaxLayer.drawText(
				MARGIN + CELL_SIZE * max,
				MARGIN + CELL_SIZE * 1.5,
				"MAX"
			);
		}
		step();
	}
	public function drawCursor(index:Int, value:Bool):Void
	{
		cursorLayer.clear();
		cursorLayer.setLineAlpha(1);
		cursorLayer.setFillAlpha(0);
		var color = if (value) 0xFF3333 else 0x6666FF;
		cursorLayer.setLineColor(color);
		cursorLayer.setFillColor(color);
		cursorLayer.setLineThickness(2);
		cursorLayer.setTextHolizontalAlign(0.5);
		
		cursorLayer.moveTo(
			MARGIN + CELL_SIZE * (index + 0.5),
			MARGIN + CELL_SIZE * 2.0
		);
		cursorLayer.arrowTo(
			MARGIN + CELL_SIZE * (index + 0.5),
			MARGIN + CELL_SIZE * 0.5,
			false,
			true,
			true,
			8,
			5
		);
		
		cursorLayer.setFillAlpha(1);
		cursorLayer.setFontStyle(true, false);
		cursorLayer.drawText(
			MARGIN + CELL_SIZE * (index + 0.5),
			MARGIN + CELL_SIZE * 2.0,
			if (value) "YES" else "NO"
		);
	}
}
