package vilog;

@:enum
abstract BlendMode(Int) to Int 
{
	var Normal     = 0 ;
	var Add        = 1 ;
	var Multiply   = 2 ;
	var Screen     = 3 ;
	var Overlay    = 4 ;
	var Darken     = 5 ;
	var Lighten    = 6 ;
	var ColorDodge = 7 ;
	var ColorBurn  = 8 ;
	var HardLight  = 9 ;
	var SoftLight  = 10;
	var Difference = 11;
	var Exclusion  = 12;
	var Hue        = 13;
	var Saturation = 14;
	var Color      = 15;
	var Luminosity = 16;
	
	public function new(value:Int)
	{
		if (value < 0 || (BlendMode.Luminosity:Int) < value)
		{
			throw "unknown blend mode: " + value;
		}
		
		this = value;
	}
}
