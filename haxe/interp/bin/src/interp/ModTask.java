// Generated by Haxe 4.1.1
package interp;

import haxe.root.*;

@SuppressWarnings(value={"rawtypes", "unchecked"})
public class ModTask extends haxe.lang.ParamEnum
{
	public ModTask(int index, java.lang.Object[] params)
	{
		//line 240 "C:\\HaxeToolkit\\haxe\\std\\java\\internal\\HxObject.hx"
		super(index, params);
	}
	
	
	public static final java.lang.String[] __hx_constructs = new java.lang.String[]{"Com", "EndList", "Func"};
	
	public static final interp.ModTask Com = new interp.ModTask(0, null);
	
	public static interp.ModTask EndList(int size)
	{
		//line 372 "C:\\Users\\909mm\\Desktop\\Work\\git\\icfpc2020\\haxe\\interp\\src\\interp\\CommandTools.hx"
		return new interp.ModTask(1, new java.lang.Object[]{size});
	}
	
	
	public static interp.ModTask Func(java.lang.String func, int size)
	{
		//line 373 "C:\\Users\\909mm\\Desktop\\Work\\git\\icfpc2020\\haxe\\interp\\src\\interp\\CommandTools.hx"
		return new interp.ModTask(2, new java.lang.Object[]{func, size});
	}
	
	
	@Override public java.lang.String getTag()
	{
		//line 369 "C:\\Users\\909mm\\Desktop\\Work\\git\\icfpc2020\\haxe\\interp\\src\\interp\\CommandTools.hx"
		return interp.ModTask.__hx_constructs[this.index];
	}
	
	
}


