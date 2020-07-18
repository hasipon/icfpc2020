package interp;
import interp.Command;
import interp.TypeError;
using interp.CommandTools;

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
		}
	}
	
	public function execute(args:Array<Command>):Command
	{
		var func = (cast this:Function);
		inline function resolve(i:Int):Command
		{
			return args[i];
		}
		
		return try 
		{
			switch (func)
			{
				case inc: resolve(0).add(Command.Int( 1));
				case dec: resolve(0).add(Command.Int(-1));
				case neg: Command.Int (-resolve(0).toInt());
				case add: resolve(0).add(resolve(1));
					
				case mul: 
					return switch [resolve(0), resolve(1)]
					{
						case [Command.Int(0), x1]:
							Command.Int(0);
						case [x0, Command.Int(0)]:
							Command.Int(0);
						case [Command.Int(1), x1]:
							x1;
						case [x0, Command.Int(1)]:
							x0;
						case [x0, x1]:
							Command.Int(x0.toInt() * x1.toInt());
					}
				case div: 
					var x1 = resolve(1).toInt();
					if (x1 == 1)
					{
						resolve(0);
					}
					else
					{
						Command.Int (resolve(0).toInt() / x1);
					}
				case eq : 
					switch (resolve(0).eq(resolve(1))) 
					{
						case MaybeBool.Unknown:
							throw new TypeError("unknown eq");
						
						case MaybeBool.True:
							Command.Func(Function.t, []);
							
						case MaybeBool.False:
							Command.Func(Function.f, []);
					}
				case lt : if (resolve(0).toInt() <  resolve(1).toInt()) Command.Func(Function.t, []) else Command.Func(Function.f, []);
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
					var x0 = 1; 
					for (i in 0...resolve(0).toInt().low)
					{
						x0 = x0 * 2;
					}
					Command.Int(x0);
					
				case i:
					resolve(0);
					
				case nil:
					Command.Func(Function.t, []);
					
				case cons:
					var x0 = resolve(0);
					var x1 = resolve(1);
					var x2 = resolve(2);
					x2.ap(x0).ap(x1);
				
				case car:
					switch (resolve(0))
					{
						case Command.Func(Function.cons, [x0, x1]):
							x0;
							
						case arg:
							arg.ap(Command.Func(Function.t, []));
					}
					
				case cdr: 
					return switch (resolve(0))
					{
						case Command.Func(Function.cons, [x0, x1]):
							x1;
							
						case arg:
							arg.ap(Command.Func(Function.f, []));
					}
					
				case isnil: 
					return switch (resolve(0))
					{
						case Command.Func(Function.nil, []):
							Command.Func(Function.t, []);
							
						case _:
							Command.Func(Function.f, []);
					}
					
				case mod:
					return Command.Modulate(resolve(0).modulate());
			}
		}
		catch (e:TypeError)
		{
			Command.Func(func, args);
		}
	}
	
	public function toString():String
	{
		return this;
	}
}
