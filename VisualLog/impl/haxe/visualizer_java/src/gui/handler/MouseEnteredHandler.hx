package gui.handler;

import java.awt.event.MouseEvent;
import java.awt.event.MouseListener;

class MouseEnteredHandler implements MouseListener
{
	private var handler:MouseEvent->Void;
	public function new(handler:MouseEvent->Void) 
	{
		this.handler = handler;
	}
	
	public function mouseEntered(event:MouseEvent) { handler(event); }
	public function mouseExited(event:MouseEvent) {}
	public function mousePressed(event:MouseEvent) {}
	public function mouseReleased(event:MouseEvent) {}
	public function mouseClicked(event:MouseEvent){}
}