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
							Command.Func(Function.f, []);
						
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
					execCar(resolve(0));
					
				case cdr: 
					execCdr(resolve(0));
					
				case isnil: 
					return switch (resolve(0))
					{
						case Command.Func(Function.nil, []):
							Command.Func(Function.t, []);
							
						case _:
							Command.Func(Function.f, []);
					}
					
				case if0:
					execIf0(resolve(0), resolve(1), resolve(2));
					
				case draw:
					Command.Func(Function.draw, args);
					
				case multipledraw:
					Command.Func(Function.multipledraw, args);
					
				case mod:
					Command.Modulate(resolve(0).modulate());
					
				case dem:
					resolve(0).dem();
					
				case modem:
					execModem(resolve(0));
					
				case f38:
					execF38(resolve(0), resolve(1));
					
				case interact:
					var x2 = resolve(0);
					var x4 = resolve(1);
					var x3 = resolve(2);
					Command.Func(
						Function.f38,
						[
							x2,
							x2.ap(x4).ap(x3)
						]
					);
					
				case send:
					Command.Func(func, args);
			}
		}
		catch (e:TypeError)
		{
			Command.Func(func, args);
		}
	}
	private static function pair(x0:Command, x1:Command):Command
	{
		return Command.Func(Function.cons, [x0, x1]);
	}
	private static function execF38(x2:Command, x0:Command):Command
	{	
		return if (execCar(x0).toInt() == 0) 
		{
			pair(
				Command.Func(Function.modem, [execCar(execCdr(x0))]), 
				pair(
					Command.Func(Function.multipledraw, [
						execCar(execCdr(execCdr(x0)))
					]),
					Command.Func(Function.nil, [])
				)
			);
		}
		else
		{
			Command.Func(Function.interact, [
				x2,
				Command.Func(Function.modem, [execCar(execCdr(x0))]), 
				Command.Func(Function.send, [
					execCar(execCdr(execCdr(x0)))
				])
			]);
		}
	}
	private static function execIf0(x0:Command, x1:Command, x2:Command):Command
	{
		return if (x0.toInt() == 0) x1 else x2;
	}
	private static function execModem(command:Command):Command
	{
		return Command.Modulate(command.modulate()).dem();
	}
	private static function execCar(command:Command):Command
	{
		return switch (command)
		{
			case Command.Func(Function.cons, [x0, x1]):
				x0;
				
			case arg:
				arg.ap(Command.Func(Function.t, []));
		}
	}
	private static function execCdr(command:Command):Command
	{
		return switch (command)
		{
			case Command.Func(Function.cons, [x0, x1]):
				x1;
				
			case arg:
				arg.ap(Command.Func(Function.f, []));
		}
	}
	
	public function toString():String
	{
		return this;
	}
}
