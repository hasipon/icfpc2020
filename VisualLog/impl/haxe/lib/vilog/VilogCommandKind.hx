package vilog;

@:enum
abstract VilogCommandKind(Int) to Int
{
	var LineTo                  = 0;
	var MoveTo                  = 1;
	var QuaraticCurveTo         = 2;
	var BezierCurveTo           = 3;
	var Arc                     = 4;
	var ArcTo                   = 5;
	var Fill                    = 6;
	var ClosePath               = 7;
	var DrawCircle              = 8;
	var DrawEllipse             = 9;
	var DrawRectangle           = 10;
	var DrawRoundRectagle       = 11;
	var DrawRegularPolygon      = 12;
	var DrawStar                = 13;
	var DrawGrid                = 14;
	var DrawColumns             = 15;
	var MultiplyTranform        = 16;
	var ResetTranform           = 17;
	var MultiplyAlpha           = 18;
	var ResetAlpha              = 19;
	var SetLineAlpha            = 20;
	var SetFillAlpha            = 21;
	var SetLineColor            = 22;
	var SetFillColor            = 23;
	var SetLineThickness        = 24;
	var SetBlendMode            = 25;
	var SetLineAlignment        = 26;
	var SetFonts                = 27;
	var SetFontSize             = 28;
	var SetFontStyle            = 29;
	var SetTextHolizontalAlign  = 30;
	var SetTextVerticalAlign    = 31;
	var DrawText                = 32;
	var SetImageHolizontalAlign = 33;
	var SetImageVerticalAlign   = 34;
	var DrawImage               = 35;
	var StartMaskingRegion      = 36;
	var StartMaskedRegion       = 37;
	var EndMaskRegion           = 38;
	var ReferenceCommands_16_8  = 39;
	var ReferenceCommands_24_16 = 40;
	var ReferenceCommands_32_24 = 41;
	var ArrowTo                 = 42;
	var CurveArrowTo            = 43;
	var ArcArrow                = 44;
	
	public function new(byte:Int)
	{
		this = byte;
	}
}
