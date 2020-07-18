package gui.handler;

import java.awt.event.MouseEvent;
import java.awt.event.MouseMotionListener;

class MouseMovedHandler implements MouseMotionListener
{
	private var handler:MouseEvent->Void;
	public function new(handler:MouseEvent->Void) 
	{
		this.handler = handler;
	}
	
	public function mouseDragged(event:MouseEvent) {}
	public function mouseMoved(event:MouseEvent){ handler(event); }
}
