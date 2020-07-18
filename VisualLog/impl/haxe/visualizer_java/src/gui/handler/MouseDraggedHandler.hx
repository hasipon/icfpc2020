package gui.handler;

import java.awt.event.MouseEvent;
import java.awt.event.MouseMotionListener;

class MouseDraggedHandler implements MouseMotionListener
{
	private var handler:MouseEvent->Void;
	public function new(handler:MouseEvent->Void) 
	{
		this.handler = handler;
	}
	
	public function mouseDragged(event:MouseEvent) { handler(event); }
	public function mouseMoved(event:MouseEvent){}
}
