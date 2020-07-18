package gui.menu;
import framework.tree.NodeHolder;
import gui.handler.ActionHandler;
import gui.handler.WindowClosingHandler;
import gui.root.RootView;
import haxe.ds.Option;
import java.awt.FileDialog;
import java.awt.Frame;
import java.awt.event.ActionEvent;
import java.awt.event.WindowEvent;
import java.javax.swing.JMenu;
import java.javax.swing.JMenuBar;
import java.javax.swing.JMenuItem;

class MenuView extends NodeHolder
{
	private var logic:MenuLogic;
	private var dialog:Option<FileDialog>;
	private var root:RootView;
	
	
	public function new(
		root:RootView,
		logic:MenuLogic
	) 
	{
		super(root);
		this.root = root;
		this.logic = logic;
		this.dialog = Option.None;
		
		var menubar = new JMenuBar();
		root.frame.setJMenuBar(menubar);
		
		var menu = new JMenu("File");
		menubar.add(menu);
		
		var openItem = new JMenuItem("Open");
		menu.add(openItem);
		openItem.addActionListener(new ActionHandler(openHandler));
	}
	
	private function openHandler(event:ActionEvent):Void
	{
		logic.viewQueue.add(MenuViewCommand.Open);
	}
	
	public function update():Void
	{
		if (!node.synchronizeVersion(logic.node))
		{
			return;
		}
		
		switch (dialog)
		{
			case Option.Some(_dialog):
				if (!logic.hasDialog)
				{
					_dialog.setVisible(false);
					_dialog.dispose();
					dialog = Option.None;
				}
				
			case Option.None:
				if (logic.hasDialog)
				{
					var frame = new Frame();
					var _dialog = new FileDialog(
						frame,
						"Open",
						FileDialog.LOAD
					);
					
					dialog = Option.Some(_dialog);
					_dialog.setVisible(true);
					
					var path = _dialog.getFile();
					logic.viewQueue.add(MenuViewCommand.Select(path));
				}
		}
	}
}
