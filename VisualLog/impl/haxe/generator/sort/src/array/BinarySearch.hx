package array;

class BinarySearch 
{
	public static inline var SIZE:Int = 32;
	public static function start():Void
	{
		var writer = new BinarySearchWriter("search/binarySearch");
		var data = [for (i in 0...SIZE) SIZE * 0.6 < i];
		writer.drawArray(data);
		
		var min = 0;
		var max = SIZE;
		writer.drawMinMax(min, max, false, false);
		
		while (min != max) {
			var index = min + Std.int((max - min) / 2);
			var value = data[index];
			writer.drawCursor(index, value);
			writer.drawMinMax(min, max, false, false);
			
			if (value) {
				max = index;
			}
			else 
			{
				min = index + 1;
			}
			writer.cursorLayer.clear();
			writer.drawMinMax(min, max, !value, value);
		}
		writer.finish();
	}
}
