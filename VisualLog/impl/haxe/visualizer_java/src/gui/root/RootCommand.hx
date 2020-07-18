package gui.root;
import gui.menu.MenuViewCommand;
import gui.root.RootViewCommand;
import gui.root.layout.LayoutData;

enum RootCommand 
{
	LayoutStorage(layoutData:LayoutData);
	
	LayoutView(data:RootViewCommand);
	MenuView(data:MenuViewCommand);
}
