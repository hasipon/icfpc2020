package vilog;
import log.LogReaderBase;
import seekable.SeekableReader;
import vilog.TextureRequired;

class VilogReader extends LogReaderBase implements IVilogReader
{
	public var config(default, null):VilogConfig;

	private var _textureRequired:TextureRequired;
	
	public function new(reader:SeekableReader) 
	{
		super(reader);
		
		var name:UInt = reader.input.readInt32();
		if (name != (0x6F6C6976:UInt))
		{
			throw "visual log identifer must be " + (0x6F6C6976:UInt) + " but " + name;
		}
		var version = reader.input.readInt32();
		if (version != 1)
		{
			throw "unsupported version: " + name;
		}
		var headerSize = reader.input.readInt32();
		if (headerSize > 29)
		{
			throw "unsupported header size: " + headerSize;
		}
		
		config = new VilogConfig(
			reader.input.readInt32(),
			reader.input.readInt32(),
			reader.input.readFloat(),
			reader.input.readInt32()
		);
		
		_textureRequired = new TextureRequired(reader.input.readByte()); 
		_frameSize = reader.input.readInt32(); 
		_entrySize = reader.input.readInt32(); 
		_byteSize  = reader.input.readInt32(); 
		
		reader.seek(headerSize - 29);
		
		position = 0;
	}
	
	public function draw(previousFrame:Int, frame:Int, drawTarget:VilogDrawable):Void
	{
		prepare();
		
		for (layer in layers)
		{
			var index = layer.findEntry(frame);
			var drawLayer = drawTarget.getLayer(layer.layerDepth);
			if (index <= 0) 
			{
				drawLayer.clear();
				continue;
			}
			var clearIndex = layer.entries[index - 1].clearIndex;
			var previousIndex = layer.findEntry(previousFrame);
			
			var startIndex = if (clearIndex < previousIndex && previousIndex <= index)
			{
				previousIndex;
			}
			else
			{
				drawLayer.clear();
				clearIndex;
			}
			
			for (i in startIndex...index)
			{
				var entry = layer.entries[i];
				proceedCommands(
					drawLayer,
					entry.commandPosition, 
					entry.byteSize
				);
			}
		}
	}
	
	public function proceedCommands(
		drawLayer:VilogLayerDrawable,
		begin:UInt,
		length:UInt
	):Void
	{
		goto(begin);
		var end = begin + length;
		while (position < end)
		{
			switch (new VilogCommandKind(readByte()))
			{
				case VilogCommandKind.LineTo                 : drawLayer.lineTo(readFloat(), readFloat());
				case VilogCommandKind.MoveTo                 : drawLayer.moveTo(readFloat(), readFloat());
				case VilogCommandKind.QuaraticCurveTo        : drawLayer.quaraticCurveTo(readFloat(), readFloat(), readFloat(), readFloat());
				case VilogCommandKind.BezierCurveTo          : drawLayer.bezierCurveTo(readFloat(), readFloat(), readFloat(), readFloat(), readFloat(), readFloat());
				case VilogCommandKind.Arc                    : drawLayer.arc(readFloat(), readFloat(), readFloat(), readRotation(1), readRotation(1), readBool());
				case VilogCommandKind.ArcTo                  : drawLayer.arcTo(readFloat(), readFloat(), readFloat(), readFloat(), readFloat());
				case VilogCommandKind.Fill                   : drawLayer.fill();
				case VilogCommandKind.ClosePath              : drawLayer.closePath();
				case VilogCommandKind.DrawCircle             : drawLayer.drawCircle(readFloat(), readFloat(), readFloat());
				case VilogCommandKind.DrawEllipse            : drawLayer.drawEllipse(readFloat(), readFloat(), readFloat(), readFloat());
				case VilogCommandKind.DrawRectangle          : drawLayer.drawRectangle(readFloat(), readFloat(), readFloat(), readFloat());
				case VilogCommandKind.DrawRoundRectagle      : drawLayer.drawRoundedRectangle(readFloat(), readFloat(), readFloat(), readFloat(), readFloat());
				case VilogCommandKind.DrawRegularPolygon     : var points; drawLayer.drawRegularPolygon(readFloat(), readFloat(), points = readUInt16(), readFloat(), readRotation(points));
				case VilogCommandKind.DrawStar               : var points; drawLayer.drawStar(readFloat(), readFloat(), points = readUInt16(), readFloat(), readFloat(), readRotation(points));
				case VilogCommandKind.DrawGrid               : drawLayer.drawGrid(readFloat(), readFloat(), readUInt16(), readUInt16(), readFloat(), readFloat());
				case VilogCommandKind.DrawColumns            : drawLayer.drawColumns(readFloat(), readFloat(), readFloat(), readFloat(), readArrayFloat());
				case VilogCommandKind.MultiplyTranform       : drawLayer.multplyTransform(readFloat(), readFloat(), readFloat(), readFloat(), readFloat(), readFloat());
				case VilogCommandKind.ResetTranform          : drawLayer.resetTransform(readFloat(), readFloat(), readFloat(), readFloat(), readFloat(), readFloat());
				case VilogCommandKind.MultiplyAlpha          : drawLayer.multplyAlpha(readAlpha());
				case VilogCommandKind.ResetAlpha             : drawLayer.resetAlpha(readAlpha());
				case VilogCommandKind.SetLineAlpha           : drawLayer.setLineAlpha(readAlpha());
				case VilogCommandKind.SetFillAlpha           : drawLayer.setFillAlpha(readAlpha());
				case VilogCommandKind.SetLineColor           : drawLayer.setLineColor(readUInt24());
				case VilogCommandKind.SetFillColor           : drawLayer.setFillColor(readUInt24());
				case VilogCommandKind.SetLineThickness       : drawLayer.setLineThickness(readFloat());
				case VilogCommandKind.SetBlendMode           : drawLayer.setBlendMode(new BlendMode(readByte()));
				case VilogCommandKind.SetLineAlignment       : drawLayer.setLineAlignment(readFloat());
				case VilogCommandKind.SetFonts               : drawLayer.setFonts(readArrayString());
				case VilogCommandKind.SetFontSize            : drawLayer.setFontSize(readFloat());
				case VilogCommandKind.SetFontStyle           : 
					var flags = readByte(); 
					drawLayer.setFontStyle(
						flags & 0x1 == 0x1,
						flags & 0x2 == 0x2
					);
				case VilogCommandKind.SetTextHolizontalAlign : drawLayer.setTextHolizontalAlign(readFloat());
				case VilogCommandKind.SetTextVerticalAlign   : drawLayer.setTextVerticalAlign(readFloat());
				case VilogCommandKind.DrawText               : drawLayer.drawText(readFloat(), readFloat(), readLongString());
				case VilogCommandKind.SetImageHolizontalAlign: drawLayer.setImageHolizontalAlign(readFloat());
				case VilogCommandKind.SetImageVerticalAlign  : drawLayer.setImageVerticalAlign(readFloat());
				case VilogCommandKind.DrawImage              : drawLayer.drawImage(readFloat(), readFloat(), readShortString()); 
				case VilogCommandKind.StartMaskingRegion     : drawLayer.startMaskingRegion();
				case VilogCommandKind.StartMaskedRegion      : drawLayer.startMaskedRegion(readUInt16());
				case VilogCommandKind.EndMaskRegion          : drawLayer.endMaskRegion();
				case VilogCommandKind.ReferenceCommands_16_8 : referenceCommands(drawLayer, readUInt16(), readByte());
				case VilogCommandKind.ReferenceCommands_24_16: referenceCommands(drawLayer, readUInt24(), readUInt16());
				case VilogCommandKind.ReferenceCommands_32_24: referenceCommands(drawLayer, readInt32() , readUInt24());
				case VilogCommandKind.ArrowTo: 
					var toX = readFloat();
					var toY = readFloat();
					var flags = readByte();
					drawLayer.arrowTo(
						toX,
						toY,
						flags & 0x1 == 0x1,
						flags & 0x2 == 0x2,
						flags & 0x4 == 0x4,
						readFloat(),
						readFloat()
					);
				case VilogCommandKind.CurveArrowTo: 
					var ctrlX = readFloat();
					var ctrlY = readFloat();
					var toX = readFloat();
					var toY = readFloat();
					var flags = readByte();
					drawLayer.curveArrowTo(
						ctrlX,
						ctrlY,
						toX,
						toY,
						flags & 0x1 == 0x1,
						flags & 0x2 == 0x2,
						flags & 0x4 == 0x4,
						readFloat(),
						readFloat()
					);
				case VilogCommandKind.ArcArrow: 
					var ctrlX = readFloat();
					var ctrlY = readFloat();
					var radius = readFloat();
					var startAngle = readRotation(1);
					var endAngle = readRotation(1);
					var flags = readByte();
					drawLayer.arcArrow(
						ctrlX,
						ctrlY,
						radius,
						startAngle,
						endAngle,
						flags & 0x1 == 0x1,
						flags & 0x2 == 0x2,
						flags & 0x4 == 0x4,
						flags & 0x8 == 0x8,
						readFloat(),
						readFloat()
					);
				
				case value:
					throw "unsupported visual command: " + value + " position:" + position;
			}
		}
	}
	
	
	private function referenceCommands(drawLayer:VilogLayerDrawable, begin:UInt, length:UInt):Void
	{
		var currentPosition = position;
		proceedCommands(drawLayer, begin, length);
		position = currentPosition;
	}
}
