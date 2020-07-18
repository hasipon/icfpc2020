package sort;
import sort.ArrayWithBufferWriter;

class MergeSort 
{
	public static function start():Void
	{
		var writer = new ArrayWithBufferWriter("sort/mergeSort");
		var data = Util.createArray(Sort.SIZE);
		Util.suffle(data);
		writer.printLine("start");
		writer.drawBackground(Sort.SIZE);
		writer.drawArray(data, []);
		
		var length = data.length;
		var scale = 1;
		while (length >= scale)
		{
			var max = Math.ceil(length / (scale * 2) - 0.5);
			for (i in 0...max)
			{
				var aBase   = i * scale * 2;
				var aLength = scale;
				if (aBase + aLength > length) continue;
				
				var bBase   = aBase + scale;
				var bLength = scale;
				if (bBase + bLength > length) bLength = length - bBase;
				
				var buffer = [];
				for (aOffset in 0...aLength) 
				{
					var value = data[aBase + aOffset];
					buffer[aOffset] = value;
					data[aBase + aOffset] = 0;
					writer.drawMove(
						value,
						false, aBase + aOffset,
						true, aOffset,
						Sort.SIZE
					);
				}
				writer.printLine("copy to buffer");
				writer.drawArray(data, buffer);
				writer.clearForeground();
				
				var aOffset = 0;
				var bOffset = 0;
				var insert = 0;
				while (aOffset < aLength)
				{	
					if (
						bOffset >= bLength || 
						{
							writer.printLine("compare: array[" + (bBase + bOffset) + "], buffer[" + aOffset + "]");
							writer.drawCompare(
								data[bBase + bOffset],
								false, bBase + bOffset,
								buffer[aOffset],
								true, aOffset,
								Sort.SIZE
							);
							writer.step();
							writer.clearForeground();
				
							buffer[aOffset] <= data[bBase + bOffset];
						}
					)
					{
						var value = buffer[aOffset];
						data[aBase + insert] = value;
						buffer[aOffset] = 0;
						
						writer.printLine("copy: buffer[" + (aOffset) + "] to array[" + (aBase + insert) + "]");
						writer.drawMove(
							value,
							true, aOffset,
							false, aBase + insert,
							Sort.SIZE
						);
						writer.drawArray(data, buffer);
						writer.clearForeground();
						aOffset += 1;
					}
					else
					{
						var value = data[bBase + bOffset];
						data[aBase + insert] = value;
						data[bBase + bOffset] = 0;
						
						writer.printLine("copy: array[" + (bBase + bOffset) + "] to array[" + (aBase + insert) + "]");
						writer.drawMove(
							value,
							false, bBase + bOffset,
							false, aBase + insert,
							Sort.SIZE
						);
						writer.drawArray(data, buffer);
						writer.clearForeground();
						bOffset += 1;
					}
					
					insert += 1;
				}
			}
			scale *= 2;
		}
		
		writer.printLine("finish");
		writer.drawArray(data, []);
		writer.finish();
	}
}
