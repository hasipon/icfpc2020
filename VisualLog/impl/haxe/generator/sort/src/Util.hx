package;

class Util 
{
	public static function createArray(size:Int):Array<Int>
	{
		return [for (i in 0...size) i + 1];
	}
	
	public static function suffle<T>(array:Array<T>):Void
	{
		var length = array.length;
		for (i in 0...length)
		{
			var j = Std.random(length - i);
			var tmp = array[j];
			array[j] = array[i];
			array[i] = tmp;
		}
	}
}
