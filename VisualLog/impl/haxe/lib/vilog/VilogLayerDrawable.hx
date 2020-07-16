package vilog;

interface VilogLayerDrawable 
{
	public function clear():Void;
	
	// ======================
	// Draw Command
	// ======================
	public function lineTo(toX:Float, toY:Float):Void;
	public function moveTo(toX:Float, toY:Float):Void;
	public function quaraticCurveTo(ctrlX:Float, ctrlY:Float, toX:Float, toY:Float):Void;
	public function bezierCurveTo(
		ctrlX:Float, ctrlY:Float, 
		ctrl2X:Float, ctrl2Y:Float, 
		toX:Float, toY:Float
	):Void;
	public function arc(
		ctrlX:Float, ctrlY:Float,
		radius:Float, 
		startAngle:Float,
		endAngle:Float,
		anticlockwise:Bool
	):Void;
	public function arcTo(
		ctrlX:Float, ctrlY:Float,
		toX:Float, toY:Float,
		radius:Float
	):Void;
	public function fill():Void;
	public function closePath():Void;
	public function drawCircle(
		x:Float, y:Float,
		radius:Float
	):Void;
	public function drawEllipse(
		x:Float, y:Float,
		width:Float, height:Float
	):Void;
	public function drawRectangle(
		x:Float, y:Float,
		width:Float, height:Float
	):Void;
	public function drawRoundedRectangle(
		x:Float, y:Float,
		width:Float, height:Float,
		radius:Float
	):Void;
	public function drawRegularPolygon(
		x:Float, y:Float,
		points:UInt,
		radius:Float,
		rotation:Float
	):Void;
	public function drawStar(
		x:Float, y:Float,
		points:UInt,
		radius:Float,
		innerRadius:Float,
		rotation:Float
	):Void;
	public function drawGrid(
		x:Float, y:Float,
		gridWidth:UInt,
		gridHeight:UInt,
		cellWidth:Float,
		cellHeight:Float
	):Void;
	public function drawColumns(
		x:Float, bottom:Float,
		columnWidth:Float,
		margin:Float,
		heights:Array<Float>,
		scaleY:Float = 1
	):Void;
	
	public function arrowTo(
		toX:Float, 
		toY:Float,
		tailVisible:Bool,
		bodyVisible:Bool,
		headVisible:Bool,
		arrowWidth:Float,
		arrowLength:Float
	):Void;
	public function curveArrowTo(
		ctrlX:Float, 
		ctrlY:Float,
		toX:Float, 
		toY:Float,
		tailVisible:Bool,
		bodyVisible:Bool,
		headVisible:Bool,
		arrowWidth:Float,
		arrowLength:Float
	):Void;
	public function arcArrow(
		ctrlX:Float, ctrlY:Float,
		radius:Float, 
		startAngle:Float,
		endAngle:Float,
		anticlockwise:Bool,
		tailVisible:Bool,
		bodyVisible:Bool,
		headVisible:Bool,
		arrowWidth:Float,
		arrowLength:Float
	):Void;
	
	
	
	// ======================
	// Property Command
	// ======================
	public function multplyTransform(
		a:Float, b:Float,
		c:Float, d:Float,
		tx:Float, ty:Float
	):Void;
	public function resetTransform(
		a:Float, b:Float,
		c:Float, d:Float,
		tx:Float, ty:Float
	):Void;
	public function multplyAlpha(alpha:Float):Void;
	public function resetAlpha(alpha:Float):Void;
	public function setLineAlpha(alpha:Float):Void;
	public function setFillAlpha(alpha:Float):Void;
	public function setLineColor(rgb:Int):Void;
	public function setFillColor(rgb:Int):Void;
	public function setLineThickness(thickness:Float):Void;
	public function setBlendMode(blendMode:BlendMode):Void;
	public function setLineAlignment(alignment:Float):Void;
	
	
	
	// ======================
	// Text Command
	// ======================
	public function setFonts(fonts:Array<String>):Void;
	public function setFontSize(size:Float):Void;
	public function setFontStyle(bold:Bool, italic:Bool):Void;
	public function setTextHolizontalAlign(align:Float):Void;
	public function setTextVerticalAlign(align:Float):Void;
	public function drawText(
		x:Float, y:Float,
		string:String
	):Void;
	

	
	// ======================
	// DRAW IMAGE COMMAND
	// ======================
	public function setImageHolizontalAlign(align:Float):Void;
	public function setImageVerticalAlign(align:Float):Void;
	public function drawImage(
		x:Float,
		y:Float,
		path:String
	):Void;
	
	
	
	// ======================
	// MASK COMMAND
	// ======================
	public function startMaskingRegion():Void;
	public function startMaskedRegion(maskIndexFromLast:UInt):Void;
	public function endMaskRegion():Void;
}
