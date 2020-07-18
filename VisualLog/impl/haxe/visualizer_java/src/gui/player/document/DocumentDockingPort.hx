package gui.player.document;

import java.awt.Color;
import java.javax.swing.JTabbedPane;
import java.lang.Class;
import org.flexdock.docking.DockingManager;
import org.flexdock.docking.DockingPort;
import org.flexdock.docking.defaults.DefaultDockingPort;
import org.flexdock.docking.defaults.DefaultDockingStrategy;
import org.flexdock.docking.defaults.StandardBorderManager;
import org.flexdock.docking.event.TabbedDragListener;
import org.flexdock.plaf.common.border.RoundedLineBorder;

class DocumentDockingPort extends DefaultDockingPort
{
	public var tabbedPanel:DraggableTabbedPane;
	
	public function new() 
	{
		super();
		
		var clazz = cast (DocumentDockingPort, java.lang.Class<Dynamic>);
        DockingManager.setDockingStrategy(clazz, new DocumentDockingStrategy());
		
		setBorderManager(new StandardBorderManager(new RoundedLineBorder(new Color(0xE4E4E4), 8, 1)));
		getDockingProperties().setTabPlacement(1);
		getDockingProperties().setSingleTabsAllowed(true);
		setTabsAsDragSource(true);
	}
	
	@:overload
    private override function createTabbedPane():JTabbedPane
	{	
		tabbedPanel = new DraggableTabbedPane();
		var listener = new TabbedDragListener();
		tabbedPanel.addMouseListener(listener);
		tabbedPanel.addMouseMotionListener(listener);
		return tabbedPanel;
	}
}

private class DocumentDockingStrategy extends DefaultDockingStrategy 
{
	@:overload
	private override function createDockingPortImpl(base:DockingPort):DockingPort
	{
		return new DocumentDockingPort();
	}
}
