package gui.handler;

import java.awt.event.MouseEvent;
import java.awt.event.MouseListener;

class MousePressedHandler implements MouseListener
{
	private var handler:MouseEvent->Void;
	public function new(handler:MouseEvent->Void) 
	{
		this.handler = handler;
	}
	
	public function mouseEntered(event:MouseEvent) {}
	public function mouseExited(event:MouseEvent) {}
	public function mousePressed(event:MouseEvent) { handler(event); }
	public function mouseReleased(event:MouseEvent) {}
	public function mouseClicked(event:MouseEvent){}
}