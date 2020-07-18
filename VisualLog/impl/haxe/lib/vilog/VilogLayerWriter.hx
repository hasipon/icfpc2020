package vilog;
import haxe.io.Bytes;
import log.LogLayerWriterBase;

@:access(vilog.VilogWriter)
class VilogLayerWriter extends LogLayerWriterBase implements VilogLayerDrawable
{
	private var visualParent:VilogWriter;
	
	public function new(
		parent:VilogWriter,
		layerDepth:Int
	) 
	{
		super(parent, layerDepth);
		visualParent = parent;
	}

	// ======================
	// Draw Command
	// ======================
	public function lineTo(toX:Float, toY:Float):Void
	{
		bytesBuffer.writeByte(VilogCommandKind.LineTo);
		bytesBuffer.writeFloat(toX);
		bytesBuffer.writeFloat(toY);
	}
	public function moveTo(toX:Float, toY:Float):Void
	{
		bytesBuffer.writeByte(VilogCommandKind.MoveTo);
		bytesBuffer.writeFloat(toX);
		bytesBuffer.writeFloat(toY);
	}
	public function quaraticCurveTo(ctrlX:Float, ctrlY:Float, toX:Float, toY:Float):Void
	{
		bytesBuffer.writeByte(VilogCommandKind.QuaraticCurveTo);
		bytesBuffer.writeFloat(ctrlX);
		bytesBuffer.writeFloat(ctrlY);
		bytesBuffer.writeFloat(toX);
		bytesBuffer.writeFloat(toY);
	}
	public function bezierCurveTo(
		ctrlX:Float, ctrlY:Float, 
		ctrl2X:Float, ctrl2Y:Float, 
		toX:Float, toY:Float
	):Void
	{
		bytesBuffer.writeByte(VilogCommandKind.BezierCurveTo);
		bytesBuffer.writeFloat(ctrlX);
		bytesBuffer.writeFloat(ctrlY);
		bytesBuffer.writeFloat(ctrl2X);
		bytesBuffer.writeFloat(ctrl2Y);
		bytesBuffer.writeFloat(toX);
		bytesBuffer.writeFloat(toY);
	}
	public function arc(
		ctrlX:Float, ctrlY:Float,
		radius:Float, 
		startAngle:Float,
		endAngle:Float,
		anticlockwise:Bool
	):Void
	{
		bytesBuffer.writeByte(VilogCommandKind.Arc);
		bytesBuffer.writeFloat(ctrlX);
		bytesBuffer.writeFloat(ctrlY);
		bytesBuffer.writeFloat(radius);
		writeRotation(startAngle, 1);
		writeRotation(endAngle, 1);
		bytesBuffer.writeByte(if (anticlockwise) 1 else 0);
	}
	public function arcTo(
		ctrlX:Float, ctrlY:Float,
		toX:Float, toY:Float,
		radius:Float
	):Void
	{
		bytesBuffer.writeByte(VilogCommandKind.ArcTo);
		bytesBuffer.writeFloat(ctrlX);
		bytesBuffer.writeFloat(ctrlY);
		bytesBuffer.writeFloat(toX);
		bytesBuffer.writeFloat(toY);
		bytesBuffer.writeFloat(radius);
	}
	public function fill():Void
	{
		bytesBuffer.writeByte(VilogCommandKind.Fill);
	}
	public function closePath():Void
	{
		bytesBuffer.writeByte(VilogCommandKind.ClosePath);
	}
	public function drawCircle(
		x:Float, y:Float,
		radius:Float
	):Void
	{
		bytesBuffer.writeByte(VilogCommandKind.DrawCircle);
		bytesBuffer.writeFloat(x);
		bytesBuffer.writeFloat(y);
		bytesBuffer.writeFloat(radius);
	}
	public function drawEllipse(
		x:Float, y:Float,
		width:Float, height:Float
	):Void
	{
		bytesBuffer.writeByte(VilogCommandKind.DrawEllipse);
		bytesBuffer.writeFloat(x);
		bytesBuffer.writeFloat(y);
		bytesBuffer.writeFloat(width);
		bytesBuffer.writeFloat(height);
	}
	public function drawRectangle(
		x:Float, y:Float,
		width:Float, height:Float
	):Void
	{
		bytesBuffer.writeByte(VilogCommandKind.DrawRectangle);
		bytesBuffer.writeFloat(x);
		bytesBuffer.writeFloat(y);
		bytesBuffer.writeFloat(width);
		bytesBuffer.writeFloat(height);
	}
	public function drawRoundedRectangle(
		x:Float, y:Float,
		width:Float, height:Float,
		radius:Float
	):Void
	{
		bytesBuffer.writeByte(VilogCommandKind.DrawRoundRectagle);
		bytesBuffer.writeFloat(x);
		bytesBuffer.writeFloat(y);
		bytesBuffer.writeFloat(width);
		bytesBuffer.writeFloat(height);
		bytesBuffer.writeFloat(radius);
	}
	private function writeRotation(rotation:Float, points:UInt):Void
	{
		var max = Math.PI * 2 / points;
		var uintAlpha = if (rotation >= max) 65535 else if (rotation <= 0) 0 else Std.int(rotation / max * 65535);
		bytesBuffer.writeUInt16(uintAlpha);
	}
	public function drawRegularPolygon(
		x:Float, y:Float,
		points:UInt,
		radius:Float,
		rotation:Float
	):Void
	{
		bytesBuffer.writeByte(VilogCommandKind.DrawRegularPolygon);
		bytesBuffer.writeFloat(x);
		bytesBuffer.writeFloat(y);
		bytesBuffer.writeUInt16(points);
		bytesBuffer.writeFloat(radius);
		writeRotation(rotation, points);
	}
	public function drawStar(
		x:Float, y:Float,
		points:UInt,
		radius:Float,
		innerRadius:Float,
		rotation:Float
	):Void
	{
		bytesBuffer.writeByte(VilogCommandKind.DrawStar);
		bytesBuffer.writeFloat(x);
		bytesBuffer.writeFloat(y);
		bytesBuffer.writeUInt16(points);
		bytesBuffer.writeFloat(radius);
		bytesBuffer.writeFloat(innerRadius);
		writeRotation(rotation, points);
	}
	public function drawGrid(
		x:Float, y:Float,
		gridWidth:UInt,
		gridHeight:UInt,
		cellWidth:Float,
		cellHeight:Float
	):Void
	{
		bytesBuffer.writeByte(VilogCommandKind.DrawGrid);
		bytesBuffer.writeFloat(x);
		bytesBuffer.writeFloat(y);
		bytesBuffer.writeUInt16(gridWidth);
		bytesBuffer.writeUInt16(gridHeight);
		bytesBuffer.writeFloat(cellWidth);
		bytesBuffer.writeFloat(cellHeight);
	}
	public function drawColumns(
		x:Float, bottom:Float,
		columnWidth:Float,
		margin:Float,
		heights:Array<Float>,
		scaleY:Float = 1
	):Void
	{
		bytesBuffer.writeByte(VilogCommandKind.DrawColumns);
		bytesBuffer.writeFloat(x);
		bytesBuffer.writeFloat(bottom);
		bytesBuffer.writeFloat(columnWidth);
		bytesBuffer.writeFloat(margin);
		bytesBuffer.writeUInt16(heights.length);
		for (height in heights)
		{
			bytesBuffer.writeFloat(height * scaleY);
		}
	}
	public function arrowTo(
		toX:Float, 
		toY:Float,
		tailVisible:Bool,
		bodyVisible:Bool,
		headVisible:Bool,
		arrowWidth:Float,
		arrowLength:Float
	):Void
	{
		bytesBuffer.writeByte(VilogCommandKind.ArrowTo);
		bytesBuffer.writeFloat(toX);
		bytesBuffer.writeFloat(toY);
		bytesBuffer.writeByte(
			(if (tailVisible) 1 else 0) |
			(if (bodyVisible) 1 else 0) << 1 |
			(if (headVisible) 1 else 0) << 2
		);
		bytesBuffer.writeFloat(arrowWidth);
		bytesBuffer.writeFloat(arrowLength);
	}
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
	):Void
	{
		bytesBuffer.writeByte(VilogCommandKind.CurveArrowTo);
		bytesBuffer.writeFloat(ctrlX);
		bytesBuffer.writeFloat(ctrlY);
		bytesBuffer.writeFloat(toX);
		bytesBuffer.writeFloat(toY);
		bytesBuffer.writeByte(
			(if (tailVisible) 1 else 0) |
			(if (bodyVisible) 1 else 0) << 1 |
			(if (headVisible) 1 else 0) << 2
		);
		bytesBuffer.writeFloat(arrowWidth);
		bytesBuffer.writeFloat(arrowLength);
	}
	public function arcArrow(
		ctrlX:Float, 
		ctrlY:Float, 
		radius:Float, 
		startAngle:Float, 
		endAngle:Float, 
		anticlockwise:Bool, 
		tailVisible:Bool, 
		bodyVisible:Bool, 
		headVisible:Bool, 
		arrowWidth:Float, 
		arrowLength:Float
	):Void 
	{
		bytesBuffer.writeByte(VilogCommandKind.ArcArrow);
		bytesBuffer.writeFloat(ctrlX);
		bytesBuffer.writeFloat(ctrlY);
		bytesBuffer.writeFloat(radius);
		writeRotation(startAngle, 1);
		writeRotation(endAngle, 1);
		bytesBuffer.writeByte(
			(if (anticlockwise) 1 else 0) |
			(if (tailVisible) 1 else 0) << 1 |
			(if (bodyVisible) 1 else 0) << 2 |
			(if (headVisible) 1 else 0) << 3
		);
		bytesBuffer.writeFloat(arrowWidth);
		bytesBuffer.writeFloat(arrowLength);
	}
	
	
	
	
	// ======================
	// Property Command
	// ======================
	public function multplyTransform(
		a:Float, b:Float,
		c:Float, d:Float,
		tx:Float, ty:Float
	):Void
	{
		bytesBuffer.writeByte(VilogCommandKind.MultiplyTranform);
		bytesBuffer.writeFloat(a);
		bytesBuffer.writeFloat(b);
		bytesBuffer.writeFloat(c);
		bytesBuffer.writeFloat(d);
		bytesBuffer.writeFloat(tx);
		bytesBuffer.writeFloat(ty);
	}
	public function resetTransform(
		a:Float, b:Float,
		c:Float, d:Float,
		tx:Float, ty:Float
	):Void
	{
		bytesBuffer.writeByte(VilogCommandKind.ResetTranform);
		bytesBuffer.writeFloat(a);
		bytesBuffer.writeFloat(b);
		bytesBuffer.writeFloat(c);
		bytesBuffer.writeFloat(d);
		bytesBuffer.writeFloat(tx);
		bytesBuffer.writeFloat(ty);
	}
	private function writeAlpha(alpha:Float):Void
	{
		var uintAlpha = if (alpha >= 1) 65535 else if (alpha <= 0) 0 else Std.int(alpha * 65535);
		bytesBuffer.writeUInt16(uintAlpha);
	}
	public function multplyAlpha(
		alpha:Float
	):Void
	{
		bytesBuffer.writeByte(VilogCommandKind.MultiplyAlpha);
		writeAlpha(alpha);
	}
	public function resetAlpha(
		alpha:Float
	):Void
	{
		bytesBuffer.writeByte(VilogCommandKind.ResetAlpha);
		writeAlpha(alpha);
	}
	public function setLineAlpha(
		alpha:Float
	):Void
	{
		bytesBuffer.writeByte(VilogCommandKind.SetLineAlpha);
		writeAlpha(alpha);
	}
	public function setFillAlpha(
		alpha:Float
	):Void
	{
		bytesBuffer.writeByte(VilogCommandKind.SetFillAlpha);
		writeAlpha(alpha);
	}
	public function setLineColor(
		rgb:Int
	):Void
	{
		bytesBuffer.writeByte(VilogCommandKind.SetLineColor);
		bytesBuffer.writeUInt24(rgb);
	}
	public function setFillColor(
		rgb:Int
	):Void
	{
		bytesBuffer.writeByte(VilogCommandKind.SetFillColor);
		bytesBuffer.writeUInt24(rgb);
	}
	public function setLineThickness(
		thickness:Float
	):Void
	{
		bytesBuffer.writeByte(VilogCommandKind.SetLineThickness);
		bytesBuffer.writeFloat(thickness);
	}
	public function setBlendMode(
		blendMode:BlendMode
	):Void
	{
		bytesBuffer.writeByte(VilogCommandKind.SetBlendMode);
		bytesBuffer.writeByte(blendMode);
	}
	public function setLineAlignment(
		alignment:Float
	):Void
	{
		bytesBuffer.writeByte(VilogCommandKind.SetLineAlignment);
		bytesBuffer.writeFloat(alignment);
	}
	
	
	
	// ======================
	// Text Command
	// ======================
	public function setFonts(
		fonts:Array<String>
	):Void
	{
		bytesBuffer.writeByte(VilogCommandKind.SetFonts);
		bytesBuffer.writeUInt16(fonts.length);
		
		for (font in fonts)
		{
			var bytes = Bytes.ofString(font);
			bytesBuffer.writeUInt16(bytes.length);
			bytesBuffer.write(bytes);
		}
	}
	public function setFontSize(size:Float):Void
	{
		bytesBuffer.writeByte(VilogCommandKind.SetFontSize);
		bytesBuffer.writeFloat(size);
	}
	public function setFontStyle(
		bold:Bool, italic:Bool
	):Void
	{
		bytesBuffer.writeByte(VilogCommandKind.SetFontStyle);
		bytesBuffer.writeByte(
			(if (bold  ) 1 else 0) |
			(if (italic) 1 else 0) << 1
		);
	}
	public function setTextHolizontalAlign(align:Float):Void
	{
		bytesBuffer.writeByte(VilogCommandKind.SetTextHolizontalAlign);
		bytesBuffer.writeFloat(align);
	}
	public function setTextVerticalAlign(align:Float):Void
	{
		bytesBuffer.writeByte(VilogCommandKind.SetTextVerticalAlign);
		bytesBuffer.writeFloat(align);
	}
	public function drawText(
		x:Float, y:Float,
		string:String
	):Void
	{
		bytesBuffer.writeByte(VilogCommandKind.DrawText);
		bytesBuffer.writeFloat(x);
		bytesBuffer.writeFloat(y);
	
		var bytes = Bytes.ofString(string);
		bytesBuffer.writeUInt24(bytes.length);
		bytesBuffer.write(bytes);
	}
	
	
	
	// ======================
	// DRAW IMAGE COMMAND
	// ======================
	public function setImageHolizontalAlign(align:Float):Void
	{
		bytesBuffer.writeByte(VilogCommandKind.SetImageHolizontalAlign);
		bytesBuffer.writeFloat(align);
	}
	public function setImageVerticalAlign(align:Float):Void
	{
		bytesBuffer.writeByte(VilogCommandKind.SetImageVerticalAlign);
		bytesBuffer.writeFloat(align);
	}
	public function drawImage(
		x:Float,
		y:Float,
		path:String
	):Void
	{
		bytesBuffer.writeByte(VilogCommandKind.DrawImage);
		bytesBuffer.writeFloat(x);
		bytesBuffer.writeFloat(y);
	
		var bytes = Bytes.ofString(path);
		bytesBuffer.writeUInt16(bytes.length);
		bytesBuffer.write(bytes);
		
		visualParent.textureRequired = true;
	}
	
	
	
	// ======================
	// MASK COMMAND
	// ======================
	public function startMaskingRegion():Void
	{
		bytesBuffer.writeByte(VilogCommandKind.StartMaskingRegion);
	}
	public function startMaskedRegion(
		maskIndexFromLast:Int
	):Void
	{
		bytesBuffer.writeByte(VilogCommandKind.StartMaskedRegion);
		bytesBuffer.writeUInt16(maskIndexFromLast);
	}
	public function endMaskRegion():Void
	{
		bytesBuffer.writeByte(VilogCommandKind.EndMaskRegion);
	}
}
