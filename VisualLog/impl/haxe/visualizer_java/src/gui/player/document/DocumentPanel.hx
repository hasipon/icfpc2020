package gui.player.document;

import gui.handler.ResizeHandler;
import java.awt.Color;
import java.awt.Component;
import java.awt.Dimension;
import java.javax.swing.JLabel;
import java.javax.swing.JPanel;
import java.javax.swing.border.LineBorder;
import org.flexdock.docking.DockingManager;
import org.flexdock.docking.defaults.AbstractDockable;
import org.flexdock.docking.defaults.DefaultDockingPort;
import java.awt.event.ComponentEvent;
import java.awt.BorderLayout;

class DocumentPanel extends AbstractDockable
{
	private var title:String;
	private var panel:JPanel;
	
	public function new(
		port:DefaultDockingPort,
		title:String
	) 
	{
		super(title);
		
		panel = new JPanel();
		panel.setLayout(new BorderLayout());
		
		var header = new JPanel();
		header.setBackground(new Color(0xFAFAFA));
		panel.add(header, BorderLayout.NORTH);
		
        getDragSources().add(header);
        getFrameDragSources().add(header);
        setTabText(title);
		
		DockingManager.registerDockable(this);
		DockingManager.dock(this, port, "CENTER");
	
		panel.setBackground(new Color(0xFAFAFA));
	}
	
	@:overload
    public override function getComponent():Component
	{
        return panel;
	}

    public function dispose():Void
	{
        DockingManager.unregisterDockable(this);
        panel = null;
	}
}
