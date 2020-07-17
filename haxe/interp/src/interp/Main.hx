package interp;

import java.Lib;

/**
 * ...
 * @author shohei909
 */
class Main 
{
	
	static function main() 
	{
		for (i in 0...0x7FFFFFFF)
		{
			waitInpt();
		}
	}
	
	static function waitInpt():Void
	{
		var line = Sys.stdin().readLine();
		var stack = line.split(" ");
		
		Sys.stdout().writeString("= " + stack.join(" ") + "\n");
	}
	
}