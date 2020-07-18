package interp;

class VirtualMachine 
{
	public var cursor :Array<Cursor>;
	public var stack  :Array<Value>;
	
	public function new(top:Array<Token>) 
	{
		this.cursor = [new Cursor(top)];
		this.stack  = [];
	}
	
	public function start():Void 
	{
		while (cursor.length > 0)
		{
			var current = cursor.pop();
			while (current.index < current.tokens.length)
			{
				stack.push(
					switch (current.tokens[current.index])
					{
						case Token.Func(func): 
							Value.Func(func, null);
							
						case Token.Ap:
							var a = stack.pop();
							if (a == null) throw "too short arguments";
							var b = stack.pop();
							if (b == null) throw "too short arguments";
							a.ap(b);
							
						case Token.Unknown(str):
							if (Main.variables.exists(str))
							{
								current.index += 1;
								cursor.push(current);
								current = new Cursor(Main.variables.get(str));
								break;
							}
							else
							{
								Value.Unknown(str, null);
							}
							
						case Token.Int(i):
							Value.Int(i);
					}
				);
				current.index += 1;
			}
		}
	}
}

private class Cursor
{
	public var tokens:Array<Token>;
	public var index :Int;
	
	public function new (tokens:Array<Token>)
	{
		this.tokens = tokens;
		this.index  = 0;
	}
}
