package gui.root.layout;
import framework.tree.NodeHolder;
import gui.root.layout.LayoutLogic;
import haxe.Json;
import io.FileUtil;
import java.awt.Frame;
import sys.FileSystem;
import sys.io.File;

class LayoutStorage extends NodeHolder
{
	private static var FILE_NAME:String = "layout.json";
	private var logic:LayoutLogic;
	
	public function new(parent:NodeHolder, logic:LayoutLogic)
	{
		super(parent);
		this.logic = logic;
		logic.storageQueue.add(load());
	}
	
	private static function getFilePath():String
	{
		return FileUtil.getRoamingPath() + "/" + FILE_NAME;
	}

	private function load():LayoutData
	{
		var path = getFilePath();
		return if (FileSystem.exists(path))
		{
			Json.parse(File.getContent(path));
		}
		else
		{
			{
				rootFrame: {
					x: 100,
					y: 100,
					width: 750,
					height: 500,
					extendedState: Frame.NORMAL,
				}
			}
		}
	}
	private function save():Void
	{
		if (logic.data != null)
		{
			var directory = FileUtil.getRoamingPath();
			if (!FileSystem.exists(directory))
			{
				FileSystem.createDirectory(directory);
			}
			File.saveContent(
				getFilePath(), 
				Json.stringify(logic.data, null, "\t")
			);
		}
	}
	
	public function update():Void
	{
		if (!node.synchronizeVersion(logic.node))
		{
			return;
		}
		save();
	}
}
