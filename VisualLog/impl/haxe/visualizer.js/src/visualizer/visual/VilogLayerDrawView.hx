package visualizer.visual;

import pixi.core.math.Point;
import haxe.ds.Option;
import pixi.core.Pixi.BlendModes;
import pixi.core.display.Container;
import pixi.core.display.DisplayObject;
import pixi.core.graphics.Graphics;
import pixi.core.math.Matrix;
import pixi.core.sprites.Sprite;
import pixi.core.text.Text;
import pixi.core.textures.Texture;
import pixi.plugins.app.Application;
import vilog.BlendMode;
import vilog.VilogLayerDrawable;

class VilogLayerDrawView implements VilogLayerDrawable
{
	private var parent:Container;
	
	public var alpha(default, null):Float;
	public var lineColor(default, null):Int;
	public var lineAlpha(default, null):Float;
	public var fillColor(default, null):Int;
	public var fillAlpha(default, null):Float;
	public var thickness(default, null):Float;
	public var lineAlignment(default, null):Float;
	public var blendMode(default, null):BlendModes;
	public var fonts(default, null):Array<String>;
	public var bold(default, null):Bool;
	public var italic(default, null):Bool;
	public var fontSize(default, null):Float;
	public var textHolizontalAlign(default, null):Float;
	public var textVerticalAlign(default, null):Float;
	public var imageHolizontalAlign(default, null):Float;
	public var imageVerticalAlign(default, null):Float;
	public var matrix(default, null):Matrix;
	
	private var container:Container;
	private var children:Array<Container>;
	private var currentState:VisualLayerDrawViewState;
	
	private var maskingContainers:Array<Container>;
	private var maskingState:MaskingState;
	
	public function new(parent:Container) 
	{
		this.parent = parent;
		parent.addChild(container = new Container());
		maskingContainers = [];
		maskingState = MaskingState.None;
		matrix = new Matrix();
		clear();
	}
	
	private function getGraphics():Graphics
	{
		return switch (currentState)
		{
			case VisualLayerDrawViewState.Graphics(graphics):
				graphics;
				
			case VisualLayerDrawViewState.None:
				var graphics = new Graphics();
				currentState = VisualLayerDrawViewState.Graphics(graphics);
				untyped graphics.lineStyle(
					thickness, 
					lineColor, 
					lineAlpha * alpha,
					lineAlignment
				);
				graphics.beginFill(
					fillColor, 
					fillAlpha * alpha
				);
				graphics.blendMode = blendMode;
				matrix.copy(graphics.localTransform);
				add(graphics);
				graphics;
		}
	}
	private function getCurrentPosition():Point
	{
		var graphics = getGraphics();
		if (untyped graphics.currentPath == null || graphics.currentPath.shape.points.length == 0)
		{
			return new Point(0, 0);
		}
		var points:Array<Float> = untyped graphics.currentPath.shape.points;
		
		return new Point(
			points[points.length - 2],
			points[points.length - 1]
		);
	}

	private function endGraphics():Void
	{
		currentState = VisualLayerDrawViewState.None;
	}
	
	public function dispose():Void
	{
		parent.removeChild(container);
	}
	
	public function clear():Void
	{
		untyped maskingContainers.length = 0;
		container.removeChildren(0, container.children.length);
		
		alpha = 1;
		lineAlpha = 1;
		lineColor = 0x999999;
		fillAlpha = 1;
		fillColor = 0xBBBBBB;
		thickness = 1;
		lineAlignment = 0.5;
		textHolizontalAlign = 0;
		textVerticalAlign = 0;
		imageHolizontalAlign = 0;
		imageVerticalAlign = 0;

		fonts = ['helvetica', 'arial', 'hiragino kaku gothic pro', 'meiryo', 'ms pgothic', 'sans-serif'];
		blendMode = BlendModes.NORMAL;
		bold = false;
		italic = false;
		
		matrix.identity();
		currentState = VisualLayerDrawViewState.None;
	}
	
	public function add(displayObject:DisplayObject):Void
	{
		switch (maskingState)
		{
			case MaskingState.Masking(child):
				child.addChild(displayObject);
			
			case MaskingState.Masked(child):
				child.addChild(displayObject);
				
			case MaskingState.None:
				container.addChild(displayObject);
		}
	}
	
	private function applyLineStyle():Void
	{
		switch (currentState)
		{
			case VisualLayerDrawViewState.Graphics(graphics):
				untyped graphics.lineStyle(
					thickness, 
					lineColor, 
					lineAlpha * alpha,
					lineAlignment
				);
				
			case VisualLayerDrawViewState.None:
		}
	}
	private function applyFillStyle():Void
	{
		switch (currentState)
		{
			case VisualLayerDrawViewState.Graphics(graphics):
				graphics.beginFill(fillColor, fillAlpha * alpha);
				
			case VisualLayerDrawViewState.None:
		}
	}
	
	public function lineTo(toX:Float, toY:Float):Void 
	{
		{ // pixi.js work around
			var from = getCurrentPosition();
			var value = 1e-8;
			getGraphics().lineTo(
				from.x + (toX - from.x) * value,
				from.y + (toY - from.y) * value
			);
		}
		getGraphics().lineTo(toX, toY);
	}
	
	public function moveTo(toX:Float, toY:Float):Void 
	{
		getGraphics().moveTo(toX, toY);
		getGraphics().lineTo(toX, toY);
	}
	
	public function quaraticCurveTo(ctrlX:Float, ctrlY:Float, toX:Float, toY:Float):Void 
	{
		{ // pixi.js work around
			var from = getCurrentPosition();
			var value = 1e-8;
			getGraphics().lineTo(
				from.x + (ctrlX - from.x) * value,
				from.y + (ctrlX - from.y) * value
			);
		}
		getGraphics().quadraticCurveTo(ctrlX, ctrlY, toX, toY);
	}
	
	public function bezierCurveTo(ctrlX:Float, ctrlY:Float, ctrl2X:Float, ctrl2Y:Float, toX:Float, toY:Float):Void 
	{
		{ // pixi.js work around
			var from = getCurrentPosition();
			var value = 1e-8;
			getGraphics().lineTo(
				from.x + (ctrlX - from.x) * value,
				from.y + (ctrlX - from.y) * value
			);
		}
		getGraphics().bezierCurveTo(ctrlX, ctrlY, ctrl2X, ctrl2Y, toX, toY);
	}
	
	public function arc(ctrlX:Float, ctrlY:Float, radius:Float, startAngle:Float, endAngle:Float, anticlockwise:Bool):Void 
	{
		getGraphics().arc(ctrlX, ctrlY, radius, startAngle, endAngle, anticlockwise);
	}
	
	public function arcTo(ctrlX:Float, ctrlY:Float, toX:Float, toY:Float, radius:Float):Void 
	{
		getGraphics().arcTo(ctrlX, ctrlY, toX, toY, radius);
	}
	
	public function fill():Void 
	{
		getGraphics().endFill();
	}
	
	public function closePath():Void 
	{
		getGraphics().closePath();
	}
	
	public function drawCircle(x:Float, y:Float, radius:Float):Void 
	{
		getGraphics().drawCircle(x, y, radius);
	}
	
	public function drawEllipse(x:Float, y:Float, width:Float, height:Float):Void 
	{
		getGraphics().drawEllipse(x, y, width, height);
	}
	
	public function drawRectangle(x:Float, y:Float, width:Float, height:Float):Void 
	{
		getGraphics().drawRect(x, y, width, height);
	}
	
	public function drawRoundedRectangle(x:Float, y:Float, width:Float, height:Float, radius:Float):Void 
	{
		getGraphics().drawRoundedRect(x, y, width, height, radius);
	}
	
	public function drawRegularPolygon(x:Float, y:Float, points:UInt, radius:Float, rotation:Float):Void 
	{
        var startAngle = - Math.PI / 2 + rotation;
        var delta = Math.PI * 2 / points;
        var polygon = [];
        for (i in 0...points)
        {
            var angle = (i * delta) + startAngle;
            polygon.push(x + (radius * Math.cos(angle)));
            polygon.push(y + (radius * Math.sin(angle)));
        }
        getGraphics().drawPolygon(polygon);
	}
	public function drawStar(x:Float, y:Float, points:UInt, radius:Float, innerRadius:Float, rotation:Float):Void 
	{
		getGraphics().drawStar(x, y, points, radius, innerRadius, rotation);
	}
	public function drawGrid(
		x:Float, y:Float,
		gridWidth:UInt,
		gridHeight:UInt,
		cellWidth:Float,
		cellHeight:Float
	):Void
	{
		var width = gridWidth * cellWidth;
		var height = gridHeight * cellHeight;
		drawRectangle(x, y, width, height);
		for (i in 1...gridWidth)
		{
			moveTo(x + cellWidth * i, y);
			lineTo(x + cellWidth * i, y + height);
		}
		for (i in 1...gridHeight)
		{
			moveTo(x        , y + cellHeight * i);
			lineTo(x + width, y + cellHeight * i);
		}
	}
	public function drawColumns(
		x:Float, bottom:Float,
		columnWidth:Float,
		margin:Float,
		heights:Array<Float>,
		scaleY:Float = 1
	):Void
	{
		for (i in 0...heights.length)
		{
			var height = heights[i];
			drawRectangle(
				x + (columnWidth + margin) * i,
				bottom - height * scaleY,
				columnWidth,
				height * scaleY
			);
		}
	}
	public function arrowTo(
		toX:Float, toY:Float,
		tailVisible:Bool,
		bodyVisible:Bool,
		headVisible:Bool,
		arrowWidth:Float,
		arrowLength:Float
	):Void
	{
		var from = getCurrentPosition();
		if (bodyVisible)
		{
			lineTo(toX, toY);
		}
		if (tailVisible)
		{
			var r = Math.atan2(toY - from.y, toX - from.x);
			var x = arrowLength;
			var y = arrowWidth / 2;
			moveTo(
				from.x + x * Math.cos(r) - y * Math.sin(r),
				from.y + x * Math.sin(r) + y * Math.cos(r)
			);
			lineTo(from.x, from.y);
			var x = arrowLength;
			var y = -arrowWidth / 2;
			lineTo(
				from.x + x * Math.cos(r) - y * Math.sin(r),
				from.y + x * Math.sin(r) + y * Math.cos(r)
			);
		}
		if (headVisible)
		{
			var r = Math.atan2(toY - from.y, toX - from.x);
			var x = -arrowLength;
			var y = arrowWidth / 2;
			moveTo(
				toX + x * Math.cos(r) - y * Math.sin(r),
				toY + x * Math.sin(r) + y * Math.cos(r)
			);
			lineTo(toX, toY);
			var x = -arrowLength;
			var y = -arrowWidth / 2;
			lineTo(
				toX + x * Math.cos(r) - y * Math.sin(r),
				toY + x * Math.sin(r) + y * Math.cos(r)
			);
		}
	}
	public function curveArrowTo(
		ctrlX:Float, ctrlY:Float,
		toX:Float, toY:Float,
		tailVisible:Bool,
		bodyVisible:Bool,
		headVisible:Bool,
		arrowWidth:Float,
		arrowLength:Float
	):Void
	{
		var from = getCurrentPosition();
		if (bodyVisible)
		{
			quaraticCurveTo(ctrlX, ctrlY, toX, toY);
		}
		if (tailVisible)
		{
			var r = Math.atan2(ctrlY - from.y, ctrlX - from.x);
			var x = arrowLength;
			var y = arrowWidth / 2;
			moveTo(
				from.x + x * Math.cos(r) - y * Math.sin(r),
				from.y + x * Math.sin(r) + y * Math.cos(r)
			);
			lineTo(from.x, from.y);
			var x = arrowLength;
			var y = -arrowWidth / 2;
			lineTo(
				from.x + x * Math.cos(r) - y * Math.sin(r),
				from.y + x * Math.sin(r) + y * Math.cos(r)
			);
		}
		if (headVisible)
		{
			var r = Math.atan2(toY - ctrlY, toX - ctrlX);
			var x = -arrowLength;
			var y = arrowWidth / 2;
			moveTo(
				toX + x * Math.cos(r) - y * Math.sin(r),
				toY + x * Math.sin(r) + y * Math.cos(r)
			);
			lineTo(toX, toY);
			var x = -arrowLength;
			var y = -arrowWidth / 2;
			lineTo(
				toX + x * Math.cos(r) - y * Math.sin(r),
				toY + x * Math.sin(r) + y * Math.cos(r)
			);
		}
	}
	public function arcArrow(
		ctrlX:Float, ctrlY:Float, 
		radius:Float, 
		startAngle:Float, endAngle:Float, 
		anticlockwise:Bool,
		tailVisible:Bool,
		bodyVisible:Bool,
		headVisible:Bool,
		arrowWidth:Float,
		arrowLength:Float
	):Void
	{
		var from = getCurrentPosition();
		if (bodyVisible)
		{
			arc(ctrlX, ctrlY, radius, startAngle, endAngle, anticlockwise);
		}
		if (tailVisible)
		{
			var r = startAngle - Math.PI / 2 * if (anticlockwise) 1 else -1;
			var baseX = ctrlX + Math.cos(startAngle) * radius;
			var baseY = ctrlY + Math.sin(startAngle) * radius;
			var x = arrowLength;
			var y = arrowWidth / 2;
			moveTo(
				baseX + x * Math.cos(r) - y * Math.sin(r),
				baseY + x * Math.sin(r) + y * Math.cos(r)
			);
			lineTo(baseX, baseY);
			var x = arrowLength;
			var y = -arrowWidth / 2;
			lineTo(
				baseX + x * Math.cos(r) - y * Math.sin(r),
				baseY + x * Math.sin(r) + y * Math.cos(r)
			);
		}
		if (headVisible)
		{
			var r = endAngle + Math.PI / 2 * if (anticlockwise) 1 else -1;
			var baseX = ctrlX + Math.cos(endAngle) * radius;
			var baseY = ctrlY + Math.sin(endAngle) * radius;
			var x = arrowLength;
			var y = arrowWidth / 2;
			moveTo(
				baseX + x * Math.cos(r) - y * Math.sin(r),
				baseY + x * Math.sin(r) + y * Math.cos(r)
			);
			lineTo(baseX, baseY);
			var x = arrowLength;
			var y = -arrowWidth / 2;
			lineTo(
				baseX + x * Math.cos(r) - y * Math.sin(r),
				baseY + x * Math.sin(r) + y * Math.cos(r)
			);
		}
	}
	
	public function multplyTransform(a:Float, b:Float, c:Float, d:Float, tx:Float, ty:Float):Void 
	{
		if (
			matrix.a  != 1 ||
			matrix.b  != 0 ||
			matrix.c  != 0 ||
			matrix.d  != 1 ||
			matrix.tx != 0 ||
			matrix.ty != 0
		)
		{
			var a1 = matrix.a;
			var b1 = matrix.b;
			var c1 = matrix.c;
			var d1 = matrix.d;
			matrix.a  = (a  * a1) + (b  * c1);
			matrix.b  = (a  * b1) + (b  * d1);
			matrix.c  = (c  * a1) + (d  * c1);
			matrix.d  = (c  * b1) + (d  * d1);
			matrix.tx = (tx * a1) + (ty * c1) + matrix.tx;
			matrix.ty = (tx * b1) + (ty * d1) + matrix.ty;
			endGraphics();
		}
	}
	
	public function resetTransform(a:Float, b:Float, c:Float, d:Float, tx:Float, ty:Float):Void 
	{
		if (
			matrix.a  != a  ||
			matrix.b  != b  ||
			matrix.c  != c  ||
			matrix.d  != d  ||
			matrix.tx != tx ||
			matrix.ty != ty
		)
		{
			matrix.a  = a ;
			matrix.b  = b ;
			matrix.c  = c ;
			matrix.d  = d ;
			matrix.tx = tx;
			matrix.ty = ty;
			endGraphics();
		}
	}
	
	public function multplyAlpha(alpha:Float):Void 
	{
		this.alpha *= alpha;
		applyLineStyle();
		applyFillStyle();
	}
	
	public function resetAlpha(alpha:Float):Void 
	{
		this.alpha = alpha;
		applyLineStyle();
		applyFillStyle();
	}
	
	public function setLineAlpha(alpha:Float):Void 
	{
		lineAlpha = alpha;
		applyLineStyle();
	}
	
	public function setFillAlpha(alpha:Float):Void 
	{
		fillAlpha = alpha;
		applyFillStyle();
	}
	
	public function setLineColor(rgb:Int):Void 
	{
		lineColor = rgb;
		applyLineStyle();
	}
	
	public function setFillColor(rgb:Int):Void 
	{
		fillColor = rgb;
		applyFillStyle();
	}
	
	public function setLineThickness(thickness:Float):Void 
	{
		this.thickness = thickness;
		applyLineStyle();
	}
	
	public function setBlendMode(blendMode:BlendMode):Void 
	{
		var newBlendMode = switch (blendMode)
		{
			case BlendMode.Normal    : BlendModes.NORMAL     ;
			case BlendMode.Add       : BlendModes.ADD        ;
			case BlendMode.Multiply  : BlendModes.MULTIPLY   ;
			case BlendMode.Screen    : BlendModes.SCREEN     ;
			case BlendMode.Overlay   : BlendModes.OVERLAY    ;
			case BlendMode.Darken    : BlendModes.DARKEN     ;
			case BlendMode.Lighten   : BlendModes.LIGHTEN    ;
			case BlendMode.ColorDodge: BlendModes.COLOR_DODGE;
			case BlendMode.ColorBurn : BlendModes.COLOR_BURN ;
			case BlendMode.HardLight : BlendModes.HARD_LIGHT ;
			case BlendMode.SoftLight : BlendModes.SOFT_LIGHT ;
			case BlendMode.Difference: BlendModes.DIFFERENCE ;
			case BlendMode.Exclusion : BlendModes.EXCLUSION  ;
			case BlendMode.Hue       : BlendModes.HUE        ;
			case BlendMode.Saturation: BlendModes.SATURATION ;
			case BlendMode.Color     : BlendModes.COLOR      ;
			case BlendMode.Luminosity: BlendModes.LUMINOSITY ;
		}
		
		if (this.blendMode != newBlendMode)
		{
			this.blendMode = newBlendMode;
			endGraphics();
		}
	}
	
	public function setLineAlignment(alignment:Float):Void 
	{
		this.lineAlignment = alignment;
		applyLineStyle();
	}
	
	public function setFonts(fonts:Array<String>):Void 
	{
		this.fonts = fonts;
	}
	
	public function setFontSize(size:Float):Void 
	{
		this.fontSize = size;
	}
	
	public function setFontStyle(bold:Bool, italic:Bool):Void 
	{
		this.bold = bold;
		this.italic = italic;
	}
	
	public function setTextHolizontalAlign(align:Float):Void 
	{
		this.textHolizontalAlign = align;
	}
	
	public function setTextVerticalAlign(align:Float):Void 
	{
		this.textVerticalAlign = align;
	}
	
	public function drawText(x:Float, y:Float, string:String):Void 
	{
		endGraphics();
		
		var maxScale = if (matrix.a > matrix.d) matrix.a else matrix.d;
		var scaleX = matrix.a / maxScale;
		var scaleY = matrix.d / maxScale;
		var text = new Text(
			string,
			{
				fill       : fillColor,
				fontSize   : fontSize * maxScale,
				fontFamily : fonts,
				fontStyle  : if (italic) "italic" else "normal",
				fontWeight : if (bold  ) "bold"   else "normal",
			}
		);

		text.x = x * matrix.a + y * matrix.c + matrix.tx;
		text.y = x * matrix.b + y * matrix.d + matrix.ty;
		text.scale.x = scaleX;
		text.skew.x  = matrix.b;
		text.skew.y  = matrix.c;
		text.scale.y = scaleY;
		text.alpha = alpha * fillAlpha;
		text.blendMode = blendMode;
		
		if (textHolizontalAlign != 0)
		{
			text.x -= textHolizontalAlign * text.width;
		}
		if (textVerticalAlign != 0)
		{
			text.y -= textVerticalAlign * text.height;
		}
		
		add(text);
	}
	
	public function setImageHolizontalAlign(align:Float):Void 
	{
		this.imageHolizontalAlign = align;
	}
	
	public function setImageVerticalAlign(align:Float):Void 
	{
		this.imageVerticalAlign = align;
	}
	
	public function drawImage(x:Float, y:Float, path:String):Void 
	{
		endGraphics();
		
		var image = new Sprite(Texture.fromFrame(path));
		image.alpha = alpha * fillAlpha;
		image.blendMode = blendMode;

		image.x = x - imageHolizontalAlign * image.width;
		image.y = y - imageVerticalAlign * image.height;
		
		matrix.copy(image.localTransform);
		add(image);
	}
	
	public function startMaskingRegion():Void 
	{
		endMaskRegion();
		
		var child = new Container();
		maskingContainers.push(child);
		maskingState = MaskingState.Masking(child);
	}
	
	public function startMaskedRegion(maskIndexFromLast:UInt):Void 
	{
		endMaskRegion();
		
		var child = new Container();
		child.mask = maskingContainers[maskingContainers.length - maskIndexFromLast - 1];
		maskingState = MaskingState.Masked(child);
	}
	
	public function endMaskRegion():Void 
	{
		endGraphics();
		maskingState = MaskingState.None;
	}
}

private enum VisualLayerDrawViewState
{
	Graphics(graphics:Graphics);
	None;
}

private enum MaskingState
{
	Masked(container:Container);
	Masking(container:Container);
	None;
}
