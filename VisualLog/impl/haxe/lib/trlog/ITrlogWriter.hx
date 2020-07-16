package trlog;

interface ITrlogWriter 
{
	// ======================
	// Frame
	// ======================
	public function step():Void;
	public function skip(frame:Int):Void;
		
	// ======================
	// Layer
	// ======================
	public function addLayer():TrlogLayerWriter;
	
	// ======================
	// Clear
	// ======================
	public function clear():Void;
	
	// ======================
	// Finish
	// ======================
	public function finish():Void;
}
