// Generated by Haxe 4.1.1
package interp._VirtualMachine;

import haxe.root.*;

@SuppressWarnings(value={"rawtypes", "unchecked"})
public class Cursor extends haxe.lang.HxObject
{
	public Cursor(haxe.lang.EmptyObject empty)
	{
	}
	
	
	public Cursor(haxe.root.Array<interp.Token> tokens)
	{
		//line 62 "C:\\Users\\909mm\\Desktop\\Work\\git\\icfpc2020\\haxe\\interp\\src\\interp\\VirtualMachine.hx"
		interp._VirtualMachine.Cursor.__hx_ctor_interp__VirtualMachine_Cursor(this, tokens);
	}
	
	
	protected static void __hx_ctor_interp__VirtualMachine_Cursor(interp._VirtualMachine.Cursor __hx_this, haxe.root.Array<interp.Token> tokens)
	{
		//line 64 "C:\\Users\\909mm\\Desktop\\Work\\git\\icfpc2020\\haxe\\interp\\src\\interp\\VirtualMachine.hx"
		__hx_this.tokens = tokens;
		//line 65 "C:\\Users\\909mm\\Desktop\\Work\\git\\icfpc2020\\haxe\\interp\\src\\interp\\VirtualMachine.hx"
		__hx_this.index = 0;
	}
	
	
	public haxe.root.Array<interp.Token> tokens;
	
	public int index;
	
	@Override public double __hx_setField_f(java.lang.String field, double value, boolean handleProperties)
	{
		//line 57 "C:\\Users\\909mm\\Desktop\\Work\\git\\icfpc2020\\haxe\\interp\\src\\interp\\VirtualMachine.hx"
		{
			//line 57 "C:\\Users\\909mm\\Desktop\\Work\\git\\icfpc2020\\haxe\\interp\\src\\interp\\VirtualMachine.hx"
			boolean __temp_executeDef1 = true;
			//line 57 "C:\\Users\\909mm\\Desktop\\Work\\git\\icfpc2020\\haxe\\interp\\src\\interp\\VirtualMachine.hx"
			if (( field != null )) 
			{
				//line 57 "C:\\Users\\909mm\\Desktop\\Work\\git\\icfpc2020\\haxe\\interp\\src\\interp\\VirtualMachine.hx"
				switch (field.hashCode())
				{
					case 100346066:
					{
						//line 57 "C:\\Users\\909mm\\Desktop\\Work\\git\\icfpc2020\\haxe\\interp\\src\\interp\\VirtualMachine.hx"
						if (field.equals("index")) 
						{
							//line 57 "C:\\Users\\909mm\\Desktop\\Work\\git\\icfpc2020\\haxe\\interp\\src\\interp\\VirtualMachine.hx"
							__temp_executeDef1 = false;
							//line 57 "C:\\Users\\909mm\\Desktop\\Work\\git\\icfpc2020\\haxe\\interp\\src\\interp\\VirtualMachine.hx"
							this.index = ((int) (value) );
							//line 57 "C:\\Users\\909mm\\Desktop\\Work\\git\\icfpc2020\\haxe\\interp\\src\\interp\\VirtualMachine.hx"
							return value;
						}
						
						//line 57 "C:\\Users\\909mm\\Desktop\\Work\\git\\icfpc2020\\haxe\\interp\\src\\interp\\VirtualMachine.hx"
						break;
					}
					
					
				}
				
			}
			
			//line 57 "C:\\Users\\909mm\\Desktop\\Work\\git\\icfpc2020\\haxe\\interp\\src\\interp\\VirtualMachine.hx"
			if (__temp_executeDef1) 
			{
				//line 57 "C:\\Users\\909mm\\Desktop\\Work\\git\\icfpc2020\\haxe\\interp\\src\\interp\\VirtualMachine.hx"
				return super.__hx_setField_f(field, value, handleProperties);
			}
			else
			{
				//line 57 "C:\\Users\\909mm\\Desktop\\Work\\git\\icfpc2020\\haxe\\interp\\src\\interp\\VirtualMachine.hx"
				throw null;
			}
			
		}
		
	}
	
	
	@Override public java.lang.Object __hx_setField(java.lang.String field, java.lang.Object value, boolean handleProperties)
	{
		//line 57 "C:\\Users\\909mm\\Desktop\\Work\\git\\icfpc2020\\haxe\\interp\\src\\interp\\VirtualMachine.hx"
		{
			//line 57 "C:\\Users\\909mm\\Desktop\\Work\\git\\icfpc2020\\haxe\\interp\\src\\interp\\VirtualMachine.hx"
			boolean __temp_executeDef1 = true;
			//line 57 "C:\\Users\\909mm\\Desktop\\Work\\git\\icfpc2020\\haxe\\interp\\src\\interp\\VirtualMachine.hx"
			if (( field != null )) 
			{
				//line 57 "C:\\Users\\909mm\\Desktop\\Work\\git\\icfpc2020\\haxe\\interp\\src\\interp\\VirtualMachine.hx"
				switch (field.hashCode())
				{
					case 100346066:
					{
						//line 57 "C:\\Users\\909mm\\Desktop\\Work\\git\\icfpc2020\\haxe\\interp\\src\\interp\\VirtualMachine.hx"
						if (field.equals("index")) 
						{
							//line 57 "C:\\Users\\909mm\\Desktop\\Work\\git\\icfpc2020\\haxe\\interp\\src\\interp\\VirtualMachine.hx"
							__temp_executeDef1 = false;
							//line 57 "C:\\Users\\909mm\\Desktop\\Work\\git\\icfpc2020\\haxe\\interp\\src\\interp\\VirtualMachine.hx"
							this.index = ((int) (haxe.lang.Runtime.toInt(value)) );
							//line 57 "C:\\Users\\909mm\\Desktop\\Work\\git\\icfpc2020\\haxe\\interp\\src\\interp\\VirtualMachine.hx"
							return value;
						}
						
						//line 57 "C:\\Users\\909mm\\Desktop\\Work\\git\\icfpc2020\\haxe\\interp\\src\\interp\\VirtualMachine.hx"
						break;
					}
					
					
					case -868186726:
					{
						//line 57 "C:\\Users\\909mm\\Desktop\\Work\\git\\icfpc2020\\haxe\\interp\\src\\interp\\VirtualMachine.hx"
						if (field.equals("tokens")) 
						{
							//line 57 "C:\\Users\\909mm\\Desktop\\Work\\git\\icfpc2020\\haxe\\interp\\src\\interp\\VirtualMachine.hx"
							__temp_executeDef1 = false;
							//line 57 "C:\\Users\\909mm\\Desktop\\Work\\git\\icfpc2020\\haxe\\interp\\src\\interp\\VirtualMachine.hx"
							this.tokens = ((haxe.root.Array<interp.Token>) (value) );
							//line 57 "C:\\Users\\909mm\\Desktop\\Work\\git\\icfpc2020\\haxe\\interp\\src\\interp\\VirtualMachine.hx"
							return value;
						}
						
						//line 57 "C:\\Users\\909mm\\Desktop\\Work\\git\\icfpc2020\\haxe\\interp\\src\\interp\\VirtualMachine.hx"
						break;
					}
					
					
				}
				
			}
			
			//line 57 "C:\\Users\\909mm\\Desktop\\Work\\git\\icfpc2020\\haxe\\interp\\src\\interp\\VirtualMachine.hx"
			if (__temp_executeDef1) 
			{
				//line 57 "C:\\Users\\909mm\\Desktop\\Work\\git\\icfpc2020\\haxe\\interp\\src\\interp\\VirtualMachine.hx"
				return super.__hx_setField(field, value, handleProperties);
			}
			else
			{
				//line 57 "C:\\Users\\909mm\\Desktop\\Work\\git\\icfpc2020\\haxe\\interp\\src\\interp\\VirtualMachine.hx"
				throw null;
			}
			
		}
		
	}
	
	
	@Override public java.lang.Object __hx_getField(java.lang.String field, boolean throwErrors, boolean isCheck, boolean handleProperties)
	{
		//line 57 "C:\\Users\\909mm\\Desktop\\Work\\git\\icfpc2020\\haxe\\interp\\src\\interp\\VirtualMachine.hx"
		{
			//line 57 "C:\\Users\\909mm\\Desktop\\Work\\git\\icfpc2020\\haxe\\interp\\src\\interp\\VirtualMachine.hx"
			boolean __temp_executeDef1 = true;
			//line 57 "C:\\Users\\909mm\\Desktop\\Work\\git\\icfpc2020\\haxe\\interp\\src\\interp\\VirtualMachine.hx"
			if (( field != null )) 
			{
				//line 57 "C:\\Users\\909mm\\Desktop\\Work\\git\\icfpc2020\\haxe\\interp\\src\\interp\\VirtualMachine.hx"
				switch (field.hashCode())
				{
					case 100346066:
					{
						//line 57 "C:\\Users\\909mm\\Desktop\\Work\\git\\icfpc2020\\haxe\\interp\\src\\interp\\VirtualMachine.hx"
						if (field.equals("index")) 
						{
							//line 57 "C:\\Users\\909mm\\Desktop\\Work\\git\\icfpc2020\\haxe\\interp\\src\\interp\\VirtualMachine.hx"
							__temp_executeDef1 = false;
							//line 57 "C:\\Users\\909mm\\Desktop\\Work\\git\\icfpc2020\\haxe\\interp\\src\\interp\\VirtualMachine.hx"
							return this.index;
						}
						
						//line 57 "C:\\Users\\909mm\\Desktop\\Work\\git\\icfpc2020\\haxe\\interp\\src\\interp\\VirtualMachine.hx"
						break;
					}
					
					
					case -868186726:
					{
						//line 57 "C:\\Users\\909mm\\Desktop\\Work\\git\\icfpc2020\\haxe\\interp\\src\\interp\\VirtualMachine.hx"
						if (field.equals("tokens")) 
						{
							//line 57 "C:\\Users\\909mm\\Desktop\\Work\\git\\icfpc2020\\haxe\\interp\\src\\interp\\VirtualMachine.hx"
							__temp_executeDef1 = false;
							//line 57 "C:\\Users\\909mm\\Desktop\\Work\\git\\icfpc2020\\haxe\\interp\\src\\interp\\VirtualMachine.hx"
							return this.tokens;
						}
						
						//line 57 "C:\\Users\\909mm\\Desktop\\Work\\git\\icfpc2020\\haxe\\interp\\src\\interp\\VirtualMachine.hx"
						break;
					}
					
					
				}
				
			}
			
			//line 57 "C:\\Users\\909mm\\Desktop\\Work\\git\\icfpc2020\\haxe\\interp\\src\\interp\\VirtualMachine.hx"
			if (__temp_executeDef1) 
			{
				//line 57 "C:\\Users\\909mm\\Desktop\\Work\\git\\icfpc2020\\haxe\\interp\\src\\interp\\VirtualMachine.hx"
				return super.__hx_getField(field, throwErrors, isCheck, handleProperties);
			}
			else
			{
				//line 57 "C:\\Users\\909mm\\Desktop\\Work\\git\\icfpc2020\\haxe\\interp\\src\\interp\\VirtualMachine.hx"
				throw null;
			}
			
		}
		
	}
	
	
	@Override public double __hx_getField_f(java.lang.String field, boolean throwErrors, boolean handleProperties)
	{
		//line 57 "C:\\Users\\909mm\\Desktop\\Work\\git\\icfpc2020\\haxe\\interp\\src\\interp\\VirtualMachine.hx"
		{
			//line 57 "C:\\Users\\909mm\\Desktop\\Work\\git\\icfpc2020\\haxe\\interp\\src\\interp\\VirtualMachine.hx"
			boolean __temp_executeDef1 = true;
			//line 57 "C:\\Users\\909mm\\Desktop\\Work\\git\\icfpc2020\\haxe\\interp\\src\\interp\\VirtualMachine.hx"
			if (( field != null )) 
			{
				//line 57 "C:\\Users\\909mm\\Desktop\\Work\\git\\icfpc2020\\haxe\\interp\\src\\interp\\VirtualMachine.hx"
				switch (field.hashCode())
				{
					case 100346066:
					{
						//line 57 "C:\\Users\\909mm\\Desktop\\Work\\git\\icfpc2020\\haxe\\interp\\src\\interp\\VirtualMachine.hx"
						if (field.equals("index")) 
						{
							//line 57 "C:\\Users\\909mm\\Desktop\\Work\\git\\icfpc2020\\haxe\\interp\\src\\interp\\VirtualMachine.hx"
							__temp_executeDef1 = false;
							//line 57 "C:\\Users\\909mm\\Desktop\\Work\\git\\icfpc2020\\haxe\\interp\\src\\interp\\VirtualMachine.hx"
							return ((double) (this.index) );
						}
						
						//line 57 "C:\\Users\\909mm\\Desktop\\Work\\git\\icfpc2020\\haxe\\interp\\src\\interp\\VirtualMachine.hx"
						break;
					}
					
					
				}
				
			}
			
			//line 57 "C:\\Users\\909mm\\Desktop\\Work\\git\\icfpc2020\\haxe\\interp\\src\\interp\\VirtualMachine.hx"
			if (__temp_executeDef1) 
			{
				//line 57 "C:\\Users\\909mm\\Desktop\\Work\\git\\icfpc2020\\haxe\\interp\\src\\interp\\VirtualMachine.hx"
				return super.__hx_getField_f(field, throwErrors, handleProperties);
			}
			else
			{
				//line 57 "C:\\Users\\909mm\\Desktop\\Work\\git\\icfpc2020\\haxe\\interp\\src\\interp\\VirtualMachine.hx"
				throw null;
			}
			
		}
		
	}
	
	
	@Override public void __hx_getFields(haxe.root.Array<java.lang.String> baseArr)
	{
		//line 57 "C:\\Users\\909mm\\Desktop\\Work\\git\\icfpc2020\\haxe\\interp\\src\\interp\\VirtualMachine.hx"
		baseArr.push("index");
		//line 57 "C:\\Users\\909mm\\Desktop\\Work\\git\\icfpc2020\\haxe\\interp\\src\\interp\\VirtualMachine.hx"
		baseArr.push("tokens");
		//line 57 "C:\\Users\\909mm\\Desktop\\Work\\git\\icfpc2020\\haxe\\interp\\src\\interp\\VirtualMachine.hx"
		super.__hx_getFields(baseArr);
	}
	
	
}


