package;
import haxe.macro.Context;
import sys.FileSystem;
import sys.io.File;

class InitializeMacro 
{
	public static function main():Void
	{
		var baseDirectory = "resources/icon";
		for (file in FileSystem.readDirectory(baseDirectory))
		{
			var path = baseDirectory + "/" + file;
			Context.addResource(
				path, 
				File.getBytes(path)
			);
		}
	}
}
