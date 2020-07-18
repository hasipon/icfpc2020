package interp;

class TokenTools 
{
	public static function toString(token:Token):String
	{
		return switch (token)
		{
			case Token.Ap           : "ap";
			case Token.Int    (i   ): i.toString();
			case Token.Unknown(u   ): u;
			case Token.Func   (func): func.toString();
		}
	}	
}