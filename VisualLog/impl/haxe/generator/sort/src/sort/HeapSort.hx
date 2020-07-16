package sort;
import sort.ArrayWithBufferWriter;
import sort.HeapSortWriter;

class HeapSort 
{
	public static function start():Void
	{
		var writer = new HeapSortWriter("sort/heapSort");
		var data = Util.createArray(Sort.SIZE);
		Util.suffle(data);
		
		writer.drawBackground(Sort.SIZE);
		writer.drawArray(data);
		
		for (i in 1...Sort.SIZE) {
			writer.drawHeap(i, Sort.SIZE);
			var current = i;
			while (current > 0) {
				var next = ((current + 1) >> 1) - 1;
				writer.drawCompare(data, next, current, true);
				writer.clearForeground();
				
				if (data[next] < data[current]) {
					var tmp = data[current];
					data[current] = data[next];
					data[next] = tmp;
					writer.drawSwap(data, next, current, true);
					writer.drawArray(data);
					writer.clearForeground();
				}
				else
				{
					break;
				}
				current = next;
			}
		}
		for (i in 1...Sort.SIZE) {
			writer.drawHeap(Sort.SIZE - 1 - i, Sort.SIZE);
			var high = Sort.SIZE - i;
			writer.drawHeap(high - 1, Sort.SIZE);
			var tmp = data[high];
			data[high] = data[0];
			data[0] = tmp;
			writer.drawSwap(data, 0, high, false);
			writer.drawArray(data);
			writer.clearForeground();
			
			var current = 0;
			while (true)
			{
				var next0 = ((current + 1) << 1) - 1;
				var next1 = ((current + 1) << 1);
				if (next0 >= high)
				{
					break;
				}
				var next = if (next1 >= high)
				{
					next0;
				}
				else
				{
					writer.drawCompare(data, next0, next1, false);
					writer.clearForeground();
					
					if (data[next0] < data[next1]) next1 else next0;
				}
				
				writer.drawCompare(data, current, next, true);
				writer.clearForeground();
					
				if (data[next] > data[current]) {
					var tmp = data[current];
					data[current] = data[next];
					data[next] = tmp;
					writer.drawSwap(data, current, next, true);
					writer.drawArray(data);
					writer.clearForeground();
				}
				else
				{
					break;
				}
				current = next;
			}
		}

		writer.printLine("finish");
		writer.finish();
	}
}
