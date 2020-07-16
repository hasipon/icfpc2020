package gui.handler;
import java.awt.event.ComponentAdapter;
import java.awt.event.ComponentEvent;

class ResizeHandler extends ComponentAdapter 
{
	private var handler:ComponentEvent->Void;
	public function new(handler:ComponentEvent->Void)
	{
		super();
		this.handler = handler;
	}
	
	@:overload
	public override function componentMoved(event:ComponentEvent):Void
	{
		handler(event);
    }
	
	@:overload
	public override function componentResized(event:ComponentEvent):Void
	{
		handler(event);
    }
}
