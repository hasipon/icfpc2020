package interp;
import interp.Function;
import interp.LinkValue;
import interp.Value;

class LinkValue 
{
	public var child:LinkValue;
	public var value:Value;
	public var size:Int;
	public function new(value:Value, child:LinkValue)
	{
		this.value = value;
		this.child = child;
		if (child == null)
		{
			size = 1;
		}
		else
		{
			size =  child.size + 1;
		}
	}
	
	public function get(i:Int):Value
	{
		return _get(size - i - 1);
	}
	
	private function _get(i:Int):Value
	{
		return if (i == 0) value else child._get(i - 1);
	}
	
	public static function create2(x0:Value, x1:Value):LinkValue
	{
		return new LinkValue(x1, new LinkValue(x0, null));
	}
	public static function create3(x0:Value, x1:Value, x2:Value):LinkValue
	{
		return new LinkValue(x2, new LinkValue(x1, new LinkValue(x0, null)));
	}
	
	public static function create1(x0:Value):LinkValue
	{
		return new LinkValue(x0, null);
	}
}