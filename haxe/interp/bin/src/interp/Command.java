// Generated by Haxe 4.1.1
package interp;

import haxe.root.*;

@SuppressWarnings(value={"rawtypes", "unchecked"})
public class Command extends haxe.lang.ParamEnum
{
	public Command(int index, java.lang.Object[] params)
	{
		//line 240 "C:\\HaxeToolkit\\haxe\\std\\java\\internal\\HxObject.hx"
		super(index, params);
	}
	
	
	public static final java.lang.String[] __hx_constructs = new java.lang.String[]{"Int", "Bool", "Func", "Ap", "Unknown"};
	
	public static interp.Command Int(int i)
	{
		//line 5 "C:\\Users\\909mm\\Desktop\\Work\\git\\icfpc2020\\haxe\\interp\\src\\interp\\Command.hx"
		return new interp.Command(0, new java.lang.Object[]{i});
	}
	
	
	public static interp.Command Bool(boolean b)
	{
		//line 6 "C:\\Users\\909mm\\Desktop\\Work\\git\\icfpc2020\\haxe\\interp\\src\\interp\\Command.hx"
		return new interp.Command(1, new java.lang.Object[]{b});
	}
	
	
	public static interp.Command Func(java.lang.String func, haxe.root.Array<interp.Command> args)
	{
		//line 7 "C:\\Users\\909mm\\Desktop\\Work\\git\\icfpc2020\\haxe\\interp\\src\\interp\\Command.hx"
		return new interp.Command(2, new java.lang.Object[]{func, args});
	}
	
	
	public static interp.Command Ap(interp.Command a, interp.Command b)
	{
		//line 8 "C:\\Users\\909mm\\Desktop\\Work\\git\\icfpc2020\\haxe\\interp\\src\\interp\\Command.hx"
		return new interp.Command(3, new java.lang.Object[]{a, b});
	}
	
	
	public static interp.Command Unknown(java.lang.String string)
	{
		//line 9 "C:\\Users\\909mm\\Desktop\\Work\\git\\icfpc2020\\haxe\\interp\\src\\interp\\Command.hx"
		return new interp.Command(4, new java.lang.Object[]{string});
	}
	
	
	@Override public java.lang.String getTag()
	{
		//line 3 "C:\\Users\\909mm\\Desktop\\Work\\git\\icfpc2020\\haxe\\interp\\src\\interp\\Command.hx"
		return interp.Command.__hx_constructs[this.index];
	}
	
	
}


