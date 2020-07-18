package gui.player.document;
import gui.handler.MouseDraggedHandler;
import gui.handler.MouseMovedHandler;
import gui.handler.MouseReleasedHandler;
import java.awt.event.MouseEvent;
import java.javax.swing.JTabbedPane;


class DraggableTabbedPane extends JTabbedPane 
{
	private var dragging = false;
	private var sourceTabIndex:Int = 0;
	public function new() 
	{
		super();
		
		addMouseListener(new MouseReleasedHandler(onMouseReleased));
		addMouseMotionListener(new MouseDraggedHandler(onMouseDragged));
	}
	
	private function onMouseDragged(event:MouseEvent):Void
	{
		if (!dragging) 
		{
			sourceTabIndex = getUI().tabForCoordinate(this, event.getX(), event.getY());
			if (sourceTabIndex >= 0) 
			{
				dragging = true;
			}
		}
	}
	private function onMouseReleased(event:MouseEvent):Void
	{
		if (dragging)
		{
			var destTabIndex = getUI().tabForCoordinate(this, event.getX(), 10);
			if (destTabIndex < 0) destTabIndex = this.getTabCount() - 1;
			if (destTabIndex != sourceTabIndex)
			{
				var comp = getComponentAt(sourceTabIndex);
				var title = getTitleAt(sourceTabIndex);
				removeTabAt(sourceTabIndex);
				insertTab(title, null, comp, null, destTabIndex);
				setSelectedIndex(destTabIndex);
			}
			dragging = false;
		}
	}
}