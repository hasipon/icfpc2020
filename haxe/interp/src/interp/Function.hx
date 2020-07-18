package interp;
import interp.LinkValue;
import interp.TypeError;

@:enum abstract Function(String) 
{
	var inc;
	var dec;
	var neg;
	var add;
	var mul;
	var div;
	var lt;
	var eq;
	var s;
	var c;
	var b;
	var t;
	var f;
	var pwr2;
	var i;
	var cons;
	var car ;
	var cdr ;
	var nil ; 
	var isnil;
	var mod;
	var dem;
	var modem;
	var if0;
	var draw;
	var multipledraw;
	var f38;
	var interact;
	var send;
	
	public function getRequiredSize():Int
	{
		return switch ((cast this:Function))
		{
			// Bool = A, B -> A
			case inc  : 1; // Int      -> Int ;
			case dec  : 1; // Int      -> Int ;
			case neg  : 1; // Int      -> Int ;
			case add  : 2; // Int, Int -> Int ;
			case mul  : 2; // Int, Int -> Int ;
			case div  : 2; // Int, Int -> Int ;
			case lt   : 2; // Int, Int -> Bool;
			case eq   : 2; // Int, Int -> Bool;
			case s    : 3; // (A -> B -> C), (A -> B), A -> C
			case c    : 3; // 
			case b    : 3; // 
			case t    : 2; // A, B -> A
			case f    : 2; // A, B -> B
			case pwr2 : 1; // Int -> Int
			case i    : 1; // A   -> A
			case cons : 3; // 
			case car  : 1; // 
			case cdr  : 1; // 
			case nil  : 1; // 
			case isnil: 1; // 
			case mod  : 1;
			case dem  : 1;
			case modem: 1;
			case if0  : 3;
			case draw : 1;
			case multipledraw: 1;
			case f38    : 2;
			case interact: 3;
			case send   : 1;
		}
	}
	
	public function getEvalThreshold():Int
	{
		return switch ((cast this:Function))
		{ 
			case cons : 1; 
			case _    : getRequiredSize(); 
		}
	}
	
	public function toString():String
	{
		return this;
	}
	
	public function execute(args:LinkValue):Value
	{
		var func = (cast this:Function);
		inline function resolve(i:Int):Value
		{
			return args.get(args.size - i - 1);
		}
		
		return try 
		{
			switch (func)
			{
				case inc: resolve(0).add(Value.Int(BigInteger.valueOf( 1)));
				case dec: resolve(0).add(Value.Int(BigInteger.valueOf(-1)));
				case neg: Value.Int(resolve(0).toInt().negate());
				case add: resolve(0).add(resolve(1));
					
				case mul: 
					return switch [resolve(0), resolve(1)]
					{
						case [Value.Int(int), x1] if (int.equals(BigInteger.ZERO)):
							Value.Int(BigInteger.ZERO);
						case [x0, Value.Int(int)] if (int.equals(BigInteger.ZERO)):
							Value.Int(BigInteger.ZERO);
						case [Value.Int(int), x1] if (int.equals(BigInteger.ONE)):
							x1;
						case [x0, Value.Int(int)] if (int.equals(BigInteger.ONE)):
							x0;
						case [x0, x1]:
							Value.Int(x0.toInt().multiply(x1.toInt()));
					}
				case div: 
					var x1 = resolve(1).toInt();
					if (x1.equals(BigInteger.ONE))
					{
						resolve(0);
					}
					else
					{
						Value.Int (resolve(0).toInt().divide(x1));
					}
				case eq : 
					switch (resolve(0).eq(resolve(1))) 
					{
						case MaybeBool.Unknown:
							Value.Func(func, args);
						
						case MaybeBool.True:
							Value.Func(Function.t, null);
							
						case MaybeBool.False:
							Value.Func(Function.f, null);
					}
					
				case lt : if (resolve(0).toInt().compareTo(resolve(1).toInt()) == -1) Value.Func(Function.t, null) else Value.Func(Function.f, null);
				
				case s:
					var x0 = resolve(0);
					var x1 = resolve(1);
					var x2 = resolve(2);
					x0.ap(x2).ap(x1.ap(x2));
				case c:
					var x0 = resolve(0);
					var x1 = resolve(1);
					var x2 = resolve(2);
					x0.ap(x2).ap(x1);
				case b:
					var x0 = resolve(0);
					var x1 = resolve(1);
					var x2 = resolve(2);
					x0.ap(x1.ap(x2));
				case t:
					resolve(0);
				case f:
					resolve(1);
				case pwr2:
					var x0 = BigInteger.ONE; 
					var two = BigInteger.valueOf(2);
					for (i in 0...resolve(0).toInt().intValue())
					{
						x0 = x0.multiply(two);
					}
					Value.Int(x0);
					
				case i:
					resolve(0);
					
				case nil:
					Value.Func(Function.t, null);
					
				case cons:
					var x0 = resolve(0);
					var x1 = resolve(1);
					var x2 = resolve(2);
					x2.ap(x0).ap(x1);
				
				case car:
					execCar(resolve(0));
					
				case cdr: 
					execCdr(resolve(0));
					
				case isnil: 
					return switch (resolve(0))
					{
						case Value.Func(Function.nil, null):
							Value.Func(Function.t, null);
							
						case _:
							Value.Func(Function.f, null);
					}
					
				case if0:
					execIf0(resolve(0), resolve(1), resolve(2));
					
				case draw:
					Value.Func(Function.draw, args);
					
				case multipledraw:
					Value.Func(Function.multipledraw, args);
					
				case mod:
					Value.Func(func, args);
					
				case dem:
					Value.Func(func, args);
					
				case modem:
					execModem(resolve(0));
					
				case f38:
					execF38(resolve(0), resolve(1));
					
				case interact:
					execInteract(
						resolve(0),
						resolve(1),
						resolve(2)
					);
					
				case send:
					execSend(resolve(0));
			}
		}
		catch (e:TypeError)
		{
			Value.Func(func, args);
		}
	}
	
	private static function execF38(x2:Value, x0:Value):Value
	{
		return try
		{
			if (execCar(x0).toInt().equals(BigInteger.ZERO)) 
			{
				pair(
					execModem(execCar(execCdr(x0))), 
					pair(
						Value.Func(Function.multipledraw, LinkValue.create1(
							execCar(execCdr(execCdr(x0)))
						)),
						Value.Func(Function.nil, null)
					)
				);
			}
			else
			{
				execInteract(
					x2,
					execModem(execCar(execCdr(x0))), 
					execSend(execCar(execCdr(execCdr(x0))))
				);
			}
		}
		catch (e:TypeError)
		{
			Value.Func(Function.f38, LinkValue.create2(x2, x0));
		}
	}
	
	private static function execInteract(x2:Value, x4:Value, x3:Value):Value
	{
		return try
		{
			execF38(
				x2,
				x2.ap(x4).ap(x3)
			);
		}
		catch (e:TypeError)
		{
			Value.Func(Function.interact, LinkValue.create3(x2, x4, x3));
		}
	}
	
	private static function pair(x0:Value, x1:Value):Value
	{
		return Value.Func(Function.cons, LinkValue.create2(x0, x1));
	}
	private static function execIf0(x0:Value, x1:Value, x2:Value):Value
	{
		return if (x0.toInt().equals(BigInteger.ZERO)) x1 else x2;
	}
	private static function execModem(command:Value):Value
	{
		return Value.Func(Function.dem, LinkValue.create1(Value.Func(Function.mod, LinkValue.create1(command))));
	}
	private static function execCar(command:Value):Value
	{
		return switch (command)
		{
			case Value.Func(Function.cons, value) if (value.size == 2):
				value.get(1);
				
			case arg:
				arg.ap(Value.Func(Function.t, null));
		}
	}
	private static function execCdr(command:Value):Value
	{
		return switch (command)
		{
			case Value.Func(Function.cons, value) if (value.size == 2):
				value.get(0);
				
			case arg:
				arg.ap(Value.Func(Function.f, null));
		}
	}
	
	private static function execSend(args:Value):Value
	{
		return Value.Func(Function.send, LinkValue.create1(args));
	}
}


