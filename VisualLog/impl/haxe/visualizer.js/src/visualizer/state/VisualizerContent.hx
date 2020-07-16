package visualizer.state;
import js.html.Element;

class VisualizerContent 
{
	public var element(default, null):Element;
	public var src(default, null):String;
	public var kind(default, null):ContentKind;

	public function new(
		element:Element,
		src:String, 
		kind:ContentKind
	)
	{
		this.kind = kind;
		this.src = src;
		this.element = element;
	}
}
