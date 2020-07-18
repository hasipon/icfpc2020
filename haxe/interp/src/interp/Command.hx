package interp;
import haxe.Int64;

enum Command
{
	Int      (i:Int64);
	Func     (func:Function, args:Array<Command>);
	Ap       (a:Command, b:Command);
	Unknown  (string:String);
}
