package visualizer.state;
import haxe.io.BytesInput;

enum VisualizerSourceState 
{
	Loading;
	Error(message:String);
	Loaded(input:BytesInput);
}