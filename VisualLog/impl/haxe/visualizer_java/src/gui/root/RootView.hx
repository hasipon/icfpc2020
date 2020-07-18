package gui.root;

import framework.tree.INodeHolder;
import framework.tree.NodeHolder;
import gui.handler.WindowClosingHandler;
import gui.menu.MenuView;
import gui.player.PlayerCtrlView;
import gui.player.document.DocumentDockingPort;
import gui.player.document.DocumentPanel;
import gui.root.RootViewCommand;
import java.awt.Color;
import java.awt.Point;
import java.awt.event.WindowEvent;
import java.awt.event.WindowListener;
import java.javax.swing.JFrame;
import java.javax.swing.JPanel;
import java.javax.swing.JButton;
import java.javax.swing.UIManager;
import java.javax.swing.JLabel;
import java.javax.swing.JComponent;
import java.javax.swing.border.LineBorder;
import java.lang.System;
import java.awt.BorderLayout;
import java.awt.Dimension;
import org.flexdock.docking.defaults.DefaultDockingPort;
import org.flexdock.docking.DockingManager;
import org.flexdock.docking.DockingConstants;
import java.javax.swing.SwingConstants;
import org.flexdock.docking.props.DockingPortPropertySet;
import org.flexdock.docking.event.TabbedDragListener;

class RootView extends NodeHolder 
{
	@:absorb
	@:forward(logic)
	private var top:gui.Top;
	
	public var frame:JFrame;
	
	private var centerPort:DocumentDockingPort;
	public var ctrl:PlayerCtrlView;
	public var menu:MenuView;
	public var playButton:JButton;
	
	private var panels:Array<DocumentPanel>;
	
	public function new(parent:INodeHolder) 
	{
		super(parent);
		
		panels = [];
		System.setProperty("sun.java2d.opengl", "True");
		 
		UIManager.setLookAndFeel(UIManager.getSystemLookAndFeelClassName());
	}
	
	public function update():Void
	{
		if (!node.synchronizeVersion(logic.node))
		{
			return;
		}
		
		if (frame == null && logic.layout.data != null)
		{
			var layout = logic.layout.data.rootFrame;
			frame = new JFrame();
			
			menu = new MenuView(this, logic.menu);
			
			centerPort = new DocumentDockingPort();
			frame.getContentPane().add(centerPort, BorderLayout.CENTER);
			
			panels.push(new DocumentPanel(centerPort, "TEST0"));
			panels.push(new DocumentPanel(centerPort, "TEST1"));
			panels.push(new DocumentPanel(centerPort, "TEST2"));
			panels.push(new DocumentPanel(centerPort, "TEST3"));
			
			ctrl = new PlayerCtrlView(this, logic.player);
			frame.getContentPane().add(ctrl.panel, BorderLayout.PAGE_END);
			
			frame.setBounds(layout.x, layout.y, layout.width, layout.height);
			frame.setDefaultCloseOperation(JFrame.EXIT_ON_CLOSE);
			frame.setVisible(true);
			frame.setExtendedState(layout.extendedState);
			frame.addWindowListener(new WindowClosingHandler(windowClosing));
			frame.setTitle("Vilog GUI");
			frame.setMinimumSize(new Dimension(360, 180));
		}
		
		if (ctrl != null) ctrl.update();
		if (menu != null) menu.update();
	}
	
	
	private function windowClosing(e:WindowEvent){
		logic.viewQueue.add(
			RootViewCommand.Close({
				rootFrame: {
					x: frame.getX(),
					y: frame.getY(),
					width: frame.getWidth(),
					height: frame.getHeight(),
					extendedState: frame.getExtendedState(),
				}
			})
		);
	}
}
