package io;
import java.lang.System;

class FileUtil
{
	public static var APPLICATION_NAME = "vilog.jar";
	
	public static function getRoamingPath():String
	{
		var os = (System.getProperty("os.name")).toUpperCase();
		var baseDirectory = if (StringTools.startsWith(os, "WIN"))
		{
			System.getenv("AppData");
		}
		else if (StringTools.startsWith(os, "MAC"))
		{
			System.getProperty("user.home") + "/Library/Application Support";
		}
		else
		{
			System.getProperty("user.home") + "/.appdata";
		}
		
		return baseDirectory + "/" + APPLICATION_NAME;
	}
}
