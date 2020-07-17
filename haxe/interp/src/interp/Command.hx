package interp;

enum Command
{
	Int    (i:Int );
	Func   (func:Function, args:Array<Command>);
	Ap     (a:Command, b:Command);
	Unknown(string:String);
}
