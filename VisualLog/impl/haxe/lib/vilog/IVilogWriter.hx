package vilog;

interface IVilogWriter
{
	// ======================
	// Frame
	// ======================
	public function step():Void;
	public function skip(frame:Int):Void;
	
	// ======================
	// Layer
	// ======================
	public function addLayer():VilogLayerWriter;

	// ======================
	// Clear
	// ======================
	public function clear():Void;
	
	// ======================
	// Finish
	// ======================
	public function finish():Void;
}
