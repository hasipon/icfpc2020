// Generated by Haxe 4.1.1
package interp;

import haxe.root.*;

@SuppressWarnings(value={"rawtypes", "unchecked"})
public class Valiables extends haxe.lang.HxObject
{
	public Valiables(haxe.lang.EmptyObject empty)
	{
	}
	
	
	public Valiables(interp.Command command)
	{
		//line 8 "C:\\Users\\909mm\\Desktop\\Work\\git\\icfpc2020\\haxe\\interp\\src\\interp\\Valiables.hx"
		interp.Valiables.__hx_ctor_interp_Valiables(this, command);
	}
	
	
	protected static void __hx_ctor_interp_Valiables(interp.Valiables __hx_this, interp.Command command)
	{
		//line 10 "C:\\Users\\909mm\\Desktop\\Work\\git\\icfpc2020\\haxe\\interp\\src\\interp\\Valiables.hx"
		__hx_this.command = command;
	}
	
	
	public interp.Command command;
	
	@Override public java.lang.Object __hx_setField(java.lang.String field, java.lang.Object value, boolean handleProperties)
	{
		//line 4 "C:\\Users\\909mm\\Desktop\\Work\\git\\icfpc2020\\haxe\\interp\\src\\interp\\Valiables.hx"
		{
			//line 4 "C:\\Users\\909mm\\Desktop\\Work\\git\\icfpc2020\\haxe\\interp\\src\\interp\\Valiables.hx"
			boolean __temp_executeDef1 = true;
			//line 4 "C:\\Users\\909mm\\Desktop\\Work\\git\\icfpc2020\\haxe\\interp\\src\\interp\\Valiables.hx"
			if (( field != null )) 
			{
				//line 4 "C:\\Users\\909mm\\Desktop\\Work\\git\\icfpc2020\\haxe\\interp\\src\\interp\\Valiables.hx"
				switch (field.hashCode())
				{
					case 950394699:
					{
						//line 4 "C:\\Users\\909mm\\Desktop\\Work\\git\\icfpc2020\\haxe\\interp\\src\\interp\\Valiables.hx"
						if (field.equals("command")) 
						{
							//line 4 "C:\\Users\\909mm\\Desktop\\Work\\git\\icfpc2020\\haxe\\interp\\src\\interp\\Valiables.hx"
							__temp_executeDef1 = false;
							//line 4 "C:\\Users\\909mm\\Desktop\\Work\\git\\icfpc2020\\haxe\\interp\\src\\interp\\Valiables.hx"
							this.command = ((interp.Command) (value) );
							//line 4 "C:\\Users\\909mm\\Desktop\\Work\\git\\icfpc2020\\haxe\\interp\\src\\interp\\Valiables.hx"
							return value;
						}
						
						//line 4 "C:\\Users\\909mm\\Desktop\\Work\\git\\icfpc2020\\haxe\\interp\\src\\interp\\Valiables.hx"
						break;
					}
					
					
				}
				
			}
			
			//line 4 "C:\\Users\\909mm\\Desktop\\Work\\git\\icfpc2020\\haxe\\interp\\src\\interp\\Valiables.hx"
			if (__temp_executeDef1) 
			{
				//line 4 "C:\\Users\\909mm\\Desktop\\Work\\git\\icfpc2020\\haxe\\interp\\src\\interp\\Valiables.hx"
				return super.__hx_setField(field, value, handleProperties);
			}
			else
			{
				//line 4 "C:\\Users\\909mm\\Desktop\\Work\\git\\icfpc2020\\haxe\\interp\\src\\interp\\Valiables.hx"
				throw null;
			}
			
		}
		
	}
	
	
	@Override public java.lang.Object __hx_getField(java.lang.String field, boolean throwErrors, boolean isCheck, boolean handleProperties)
	{
		//line 4 "C:\\Users\\909mm\\Desktop\\Work\\git\\icfpc2020\\haxe\\interp\\src\\interp\\Valiables.hx"
		{
			//line 4 "C:\\Users\\909mm\\Desktop\\Work\\git\\icfpc2020\\haxe\\interp\\src\\interp\\Valiables.hx"
			boolean __temp_executeDef1 = true;
			//line 4 "C:\\Users\\909mm\\Desktop\\Work\\git\\icfpc2020\\haxe\\interp\\src\\interp\\Valiables.hx"
			if (( field != null )) 
			{
				//line 4 "C:\\Users\\909mm\\Desktop\\Work\\git\\icfpc2020\\haxe\\interp\\src\\interp\\Valiables.hx"
				switch (field.hashCode())
				{
					case 950394699:
					{
						//line 4 "C:\\Users\\909mm\\Desktop\\Work\\git\\icfpc2020\\haxe\\interp\\src\\interp\\Valiables.hx"
						if (field.equals("command")) 
						{
							//line 4 "C:\\Users\\909mm\\Desktop\\Work\\git\\icfpc2020\\haxe\\interp\\src\\interp\\Valiables.hx"
							__temp_executeDef1 = false;
							//line 4 "C:\\Users\\909mm\\Desktop\\Work\\git\\icfpc2020\\haxe\\interp\\src\\interp\\Valiables.hx"
							return this.command;
						}
						
						//line 4 "C:\\Users\\909mm\\Desktop\\Work\\git\\icfpc2020\\haxe\\interp\\src\\interp\\Valiables.hx"
						break;
					}
					
					
				}
				
			}
			
			//line 4 "C:\\Users\\909mm\\Desktop\\Work\\git\\icfpc2020\\haxe\\interp\\src\\interp\\Valiables.hx"
			if (__temp_executeDef1) 
			{
				//line 4 "C:\\Users\\909mm\\Desktop\\Work\\git\\icfpc2020\\haxe\\interp\\src\\interp\\Valiables.hx"
				return super.__hx_getField(field, throwErrors, isCheck, handleProperties);
			}
			else
			{
				//line 4 "C:\\Users\\909mm\\Desktop\\Work\\git\\icfpc2020\\haxe\\interp\\src\\interp\\Valiables.hx"
				throw null;
			}
			
		}
		
	}
	
	
	@Override public void __hx_getFields(haxe.root.Array<java.lang.String> baseArr)
	{
		//line 4 "C:\\Users\\909mm\\Desktop\\Work\\git\\icfpc2020\\haxe\\interp\\src\\interp\\Valiables.hx"
		baseArr.push("command");
		//line 4 "C:\\Users\\909mm\\Desktop\\Work\\git\\icfpc2020\\haxe\\interp\\src\\interp\\Valiables.hx"
		super.__hx_getFields(baseArr);
	}
	
	
}


