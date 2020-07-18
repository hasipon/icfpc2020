package interp;

enum Value 
{
	Int    (refInt :BigInteger);
	Unknown(string :String  , argments:LinkValue);
	Func   (func   :Function, argments:LinkValue);
}
