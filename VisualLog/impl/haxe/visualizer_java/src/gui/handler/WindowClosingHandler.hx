package gui.handler;

import java.awt.event.WindowListener;
import java.awt.event.WindowEvent;

class WindowClosingHandler implements WindowListener
{
	private var handler:WindowEvent->Void;
	public function new(handler:WindowEvent->Void) 
	{
		this.handler = handler;
	}

	public function windowClosed(e:WindowEvent){}
	public function windowOpened(e:WindowEvent){}
	public function windowClosing(e:WindowEvent){ handler(e); }
	public function windowIconified(e:WindowEvent){}
	public function windowDeiconified(e:WindowEvent){}
	public function windowActivated(e:WindowEvent){}
	public function windowDeactivated(e:WindowEvent){}	
}