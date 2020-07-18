package gui.handler;

import java.awt.event.ActionListener;
import java.awt.event.ActionEvent;

class ActionHandler implements ActionListener
{
	private var handler:ActionEvent->Void;
	public function new(handler:ActionEvent->Void) 
	{
		this.handler = handler;
	}
	public function actionPerformed(event:ActionEvent):Void
	{
		handler(event);
	}
}
