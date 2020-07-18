package interp;

class ValueTools 
{
	public static function toString(token:Value):String
	{
		return switch (token)
		{
			case Value.Unknown(u   , args):
				var head = "";
				var tail = "";
				while (args != null)
				{
					head = head + "ap ";
					tail  = " " + args.value.toString() + tail;
					args = args.child;
				}
				head + u.toString() + tail;
				
			case Value.Int    (i   ): i.toString();
			case Value.Func   (func, args): 
				var head = "";
				var tail = "";
				while (args != null)
				{
					head = head + "ap ";
					tail = " " + args.value.toString() + tail;
					args = args.child;
				}
				head + func.toString() + tail;
		}
	}
	public static function toInt(value:Value):BigInteger
	{
		return switch (value)
		{
			case Value.Int    (i         ): i;
			case Value.Unknown(u   , args): throw new TypeError("unkown is not int");
			case Value.Func   (func, args): throw new TypeError("func is not func");
		}
	}
	public static function ap(value:Value, arg:Value):Value
	{
		return switch (value)
		{
			case Value.Int (i):
				throw "invalid ap int:" + i;
				
			case Value.Func(func, link):
				var link = new LinkValue(arg, link);
				if (func.getRequiredSize() == link.size)
				{
					func.execute(link);
				}
				else
				{
					Value.Func(func, link);
				}
				
			case Value.Unknown(str, link):
				Value.Unknown(str, new LinkValue(arg, link));
		}
	}
	
	
	public static function add(x0:Value, x1:Value):Value
	{
		return switch [x0, x1]
		{
			case [Value.Int(i), x1] if (i.equals(BigInteger.ZERO)):
				x1;
				
			case [x0, Value.Int(i)] if (i.equals(BigInteger.ZERO)):
				x0;
				
			case [Value.Int(x0), Value.Int(x1)]:
				Value.Int(x0.add(x1));
				
			case _:
				Value.Func(Function.add, LinkValue.create2(x0, x1));
		}
	}
	
	public static function eq(x0:Value, x1:Value):MaybeBool
	{
		return switch x0
		{		
			case Value.Func(func0, args0):
				MaybeBool.Unknown;
				
			case Value.Unknown(string0, args0):
				MaybeBool.Unknown;
				
			case Value.Int(i0):
				switch x1 
				{
					case Value.Int(i1) if (i0.equals(i1)):
						MaybeBool.True;
						
					case Value.Int(_):
						MaybeBool.False;
						
					case _:
						MaybeBool.Unknown;
				}
				
				
		}
	}
}
