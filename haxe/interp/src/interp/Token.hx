package interp;

enum Token 
{
	Func   (func:Function );
	Ap                     ;
	Int    (i  :BigInteger);
	Unknown(str:String    );
}
