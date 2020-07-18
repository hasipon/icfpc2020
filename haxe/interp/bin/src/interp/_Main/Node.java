// Generated by Haxe 4.1.1
package interp._Main;

import haxe.root.*;

@SuppressWarnings(value={"rawtypes", "unchecked"})
public class Node extends haxe.lang.HxObject
{
	static
	{
		//line 89 "C:\\Users\\909mm\\Desktop\\Work\\git\\icfpc2020\\haxe\\interp\\src\\interp\\Main.hx"
		interp._Main.Node.intEReg = new haxe.root.EReg("^[-0-9]+$", "");
	}
	
	public Node(haxe.lang.EmptyObject empty)
	{
	}
	
	
	public Node(interp._Main.Environment env)
	{
		//line 95 "C:\\Users\\909mm\\Desktop\\Work\\git\\icfpc2020\\haxe\\interp\\src\\interp\\Main.hx"
		interp._Main.Node.__hx_ctor_interp__Main_Node(this, env);
	}
	
	
	protected static void __hx_ctor_interp__Main_Node(interp._Main.Node __hx_this, interp._Main.Environment env)
	{
		//line 97 "C:\\Users\\909mm\\Desktop\\Work\\git\\icfpc2020\\haxe\\interp\\src\\interp\\Main.hx"
		__hx_this.env = env;
		//line 98 "C:\\Users\\909mm\\Desktop\\Work\\git\\icfpc2020\\haxe\\interp\\src\\interp\\Main.hx"
		__hx_this.output = new haxe.root.Array<interp.Command>(new interp.Command[]{});
		//line 99 "C:\\Users\\909mm\\Desktop\\Work\\git\\icfpc2020\\haxe\\interp\\src\\interp\\Main.hx"
		__hx_this.tail = new haxe.root.Array<haxe.root.Array<interp.Command>>(new haxe.root.Array[]{});
		//line 100 "C:\\Users\\909mm\\Desktop\\Work\\git\\icfpc2020\\haxe\\interp\\src\\interp\\Main.hx"
		__hx_this.child = null;
	}
	
	
	public static haxe.root.EReg intEReg;
	
	public interp._Main.Environment env;
	
	public haxe.root.Array<interp.Command> output;
	
	public interp._Main.Node child;
	
	public haxe.root.Array<haxe.root.Array<interp.Command>> tail;
	
	public void add(java.lang.String data)
	{
		//line 105 "C:\\Users\\909mm\\Desktop\\Work\\git\\icfpc2020\\haxe\\interp\\src\\interp\\Main.hx"
		if (( this.child != null )) 
		{
			//line 107 "C:\\Users\\909mm\\Desktop\\Work\\git\\icfpc2020\\haxe\\interp\\src\\interp\\Main.hx"
			if (haxe.lang.Runtime.valEq(data, "(")) 
			{
				//line 109 "C:\\Users\\909mm\\Desktop\\Work\\git\\icfpc2020\\haxe\\interp\\src\\interp\\Main.hx"
				interp.Command list = interp.Command.Func(haxe.lang.Runtime.toString("nil"), new haxe.root.Array<interp.Command>(new interp.Command[]{}));
				//line 110 "C:\\Users\\909mm\\Desktop\\Work\\git\\icfpc2020\\haxe\\interp\\src\\interp\\Main.hx"
				{
					//line 110 "C:\\Users\\909mm\\Desktop\\Work\\git\\icfpc2020\\haxe\\interp\\src\\interp\\Main.hx"
					int _g = 0;
					//line 110 "C:\\Users\\909mm\\Desktop\\Work\\git\\icfpc2020\\haxe\\interp\\src\\interp\\Main.hx"
					haxe.root.Array<haxe.root.Array<interp.Command>> _g1 = this.child.tail;
					//line 110 "C:\\Users\\909mm\\Desktop\\Work\\git\\icfpc2020\\haxe\\interp\\src\\interp\\Main.hx"
					while (( _g < _g1.length ))
					{
						//line 110 "C:\\Users\\909mm\\Desktop\\Work\\git\\icfpc2020\\haxe\\interp\\src\\interp\\Main.hx"
						haxe.root.Array<interp.Command> out = _g1.__get(_g);
						//line 110 "C:\\Users\\909mm\\Desktop\\Work\\git\\icfpc2020\\haxe\\interp\\src\\interp\\Main.hx"
						 ++ _g;
						//line 112 "C:\\Users\\909mm\\Desktop\\Work\\git\\icfpc2020\\haxe\\interp\\src\\interp\\Main.hx"
						if (( out.length > 0 )) 
						{
							//line 114 "C:\\Users\\909mm\\Desktop\\Work\\git\\icfpc2020\\haxe\\interp\\src\\interp\\Main.hx"
							list = interp.Command.Func(haxe.lang.Runtime.toString("cons"), new haxe.root.Array<interp.Command>(new interp.Command[]{((interp.Command) (out.pop()) ), list}));
						}
						
					}
					
				}
				
				//line 117 "C:\\Users\\909mm\\Desktop\\Work\\git\\icfpc2020\\haxe\\interp\\src\\interp\\Main.hx"
				if (( this.child.output.length > 0 )) 
				{
					//line 119 "C:\\Users\\909mm\\Desktop\\Work\\git\\icfpc2020\\haxe\\interp\\src\\interp\\Main.hx"
					list = interp.Command.Func(haxe.lang.Runtime.toString("cons"), new haxe.root.Array<interp.Command>(new interp.Command[]{((interp.Command) (this.child.output.pop()) ), list}));
				}
				
				//line 121 "C:\\Users\\909mm\\Desktop\\Work\\git\\icfpc2020\\haxe\\interp\\src\\interp\\Main.hx"
				this.output.push(list);
			}
			else
			{
				//line 125 "C:\\Users\\909mm\\Desktop\\Work\\git\\icfpc2020\\haxe\\interp\\src\\interp\\Main.hx"
				this.child.add(data);
			}
			
		}
		else
		{
			//line 128 "C:\\Users\\909mm\\Desktop\\Work\\git\\icfpc2020\\haxe\\interp\\src\\interp\\Main.hx"
			if (haxe.lang.Runtime.valEq(data, ",")) 
			{
				//line 130 "C:\\Users\\909mm\\Desktop\\Work\\git\\icfpc2020\\haxe\\interp\\src\\interp\\Main.hx"
				this.tail.push(this.output);
				//line 131 "C:\\Users\\909mm\\Desktop\\Work\\git\\icfpc2020\\haxe\\interp\\src\\interp\\Main.hx"
				this.output = new haxe.root.Array<interp.Command>(new interp.Command[]{});
			}
			else
			{
				//line 133 "C:\\Users\\909mm\\Desktop\\Work\\git\\icfpc2020\\haxe\\interp\\src\\interp\\Main.hx"
				if (haxe.lang.Runtime.valEq(data, ")")) 
				{
					//line 135 "C:\\Users\\909mm\\Desktop\\Work\\git\\icfpc2020\\haxe\\interp\\src\\interp\\Main.hx"
					this.child = new interp._Main.Node(((interp._Main.Environment) (this.env) ));
				}
				
			}
			
		}
		
		//line 137 "C:\\Users\\909mm\\Desktop\\Work\\git\\icfpc2020\\haxe\\interp\\src\\interp\\Main.hx"
		interp.Command command = this.getCommand(data);
		//line 138 "C:\\Users\\909mm\\Desktop\\Work\\git\\icfpc2020\\haxe\\interp\\src\\interp\\Main.hx"
		this.output.push(command);
	}
	
	
	public interp.Command getCommand(java.lang.String data)
	{
		//line 143 "C:\\Users\\909mm\\Desktop\\Work\\git\\icfpc2020\\haxe\\interp\\src\\interp\\Main.hx"
		if (haxe.lang.Runtime.valEq(data, "ap")) 
		{
			//line 145 "C:\\Users\\909mm\\Desktop\\Work\\git\\icfpc2020\\haxe\\interp\\src\\interp\\Main.hx"
			interp.Command c = ((interp.Command) (this.output.pop()) );
			//line 146 "C:\\Users\\909mm\\Desktop\\Work\\git\\icfpc2020\\haxe\\interp\\src\\interp\\Main.hx"
			if (( c == null )) 
			{
				//line 146 "C:\\Users\\909mm\\Desktop\\Work\\git\\icfpc2020\\haxe\\interp\\src\\interp\\Main.hx"
				throw ((java.lang.RuntimeException) (haxe.Exception.thrown("ap x: too short args")) );
			}
			
			//line 147 "C:\\Users\\909mm\\Desktop\\Work\\git\\icfpc2020\\haxe\\interp\\src\\interp\\Main.hx"
			interp.Command na = ((interp.Command) (this.output.pop()) );
			//line 148 "C:\\Users\\909mm\\Desktop\\Work\\git\\icfpc2020\\haxe\\interp\\src\\interp\\Main.hx"
			if (( na == null )) 
			{
				//line 148 "C:\\Users\\909mm\\Desktop\\Work\\git\\icfpc2020\\haxe\\interp\\src\\interp\\Main.hx"
				throw ((java.lang.RuntimeException) (haxe.Exception.thrown(( "ap x: too short args: " + haxe.root.Std.string(c) ))) );
			}
			
			//line 149 "C:\\Users\\909mm\\Desktop\\Work\\git\\icfpc2020\\haxe\\interp\\src\\interp\\Main.hx"
			return interp.CommandTools.ap(c, na);
		}
		
		//line 151 "C:\\Users\\909mm\\Desktop\\Work\\git\\icfpc2020\\haxe\\interp\\src\\interp\\Main.hx"
		{
			//line 151 "C:\\Users\\909mm\\Desktop\\Work\\git\\icfpc2020\\haxe\\interp\\src\\interp\\Main.hx"
			int _g = 0;
			//line 151 "C:\\Users\\909mm\\Desktop\\Work\\git\\icfpc2020\\haxe\\interp\\src\\interp\\Main.hx"
			haxe.root.Array<java.lang.String> _g1 = new haxe.root.Array<java.lang.String>(new java.lang.String[]{haxe.lang.Runtime.toString("inc"), haxe.lang.Runtime.toString("dec"), haxe.lang.Runtime.toString("neg"), haxe.lang.Runtime.toString("add"), haxe.lang.Runtime.toString("mul"), haxe.lang.Runtime.toString("div"), haxe.lang.Runtime.toString("lt"), haxe.lang.Runtime.toString("eq"), haxe.lang.Runtime.toString("s"), haxe.lang.Runtime.toString("c"), haxe.lang.Runtime.toString("b"), haxe.lang.Runtime.toString("t"), haxe.lang.Runtime.toString("f"), haxe.lang.Runtime.toString("pwr2"), haxe.lang.Runtime.toString("i"), haxe.lang.Runtime.toString("cons"), haxe.lang.Runtime.toString("car"), haxe.lang.Runtime.toString("cdr"), haxe.lang.Runtime.toString("nil"), haxe.lang.Runtime.toString("isnil"), haxe.lang.Runtime.toString("mod"), haxe.lang.Runtime.toString("if0")});
			//line 151 "C:\\Users\\909mm\\Desktop\\Work\\git\\icfpc2020\\haxe\\interp\\src\\interp\\Main.hx"
			while (( _g < _g1.length ))
			{
				//line 151 "C:\\Users\\909mm\\Desktop\\Work\\git\\icfpc2020\\haxe\\interp\\src\\interp\\Main.hx"
				java.lang.String func = _g1.__get(_g);
				//line 151 "C:\\Users\\909mm\\Desktop\\Work\\git\\icfpc2020\\haxe\\interp\\src\\interp\\Main.hx"
				 ++ _g;
				//line 153 "C:\\Users\\909mm\\Desktop\\Work\\git\\icfpc2020\\haxe\\interp\\src\\interp\\Main.hx"
				if (haxe.lang.Runtime.valEq(data, interp._Function.Function_Impl_.toString(func))) 
				{
					//line 155 "C:\\Users\\909mm\\Desktop\\Work\\git\\icfpc2020\\haxe\\interp\\src\\interp\\Main.hx"
					return interp.Command.Func(func, new haxe.root.Array<interp.Command>(new interp.Command[]{}));
				}
				
			}
			
		}
		
		//line 158 "C:\\Users\\909mm\\Desktop\\Work\\git\\icfpc2020\\haxe\\interp\\src\\interp\\Main.hx"
		if (haxe.lang.Runtime.valEq(data, "vec")) 
		{
			//line 160 "C:\\Users\\909mm\\Desktop\\Work\\git\\icfpc2020\\haxe\\interp\\src\\interp\\Main.hx"
			return interp.Command.Func(haxe.lang.Runtime.toString("cons"), new haxe.root.Array<interp.Command>(new interp.Command[]{}));
		}
		
		//line 163 "C:\\Users\\909mm\\Desktop\\Work\\git\\icfpc2020\\haxe\\interp\\src\\interp\\Main.hx"
		if (interp._Main.Node.intEReg.match(data)) 
		{
			//line 165 "C:\\Users\\909mm\\Desktop\\Work\\git\\icfpc2020\\haxe\\interp\\src\\interp\\Main.hx"
			return interp.Command.Int(haxe._Int64.Int64_Impl_.parseString(data));
		}
		
		//line 167 "C:\\Users\\909mm\\Desktop\\Work\\git\\icfpc2020\\haxe\\interp\\src\\interp\\Main.hx"
		return interp.Command.Unknown(data);
	}
	
	
	@Override public java.lang.Object __hx_setField(java.lang.String field, java.lang.Object value, boolean handleProperties)
	{
		//line 87 "C:\\Users\\909mm\\Desktop\\Work\\git\\icfpc2020\\haxe\\interp\\src\\interp\\Main.hx"
		{
			//line 87 "C:\\Users\\909mm\\Desktop\\Work\\git\\icfpc2020\\haxe\\interp\\src\\interp\\Main.hx"
			boolean __temp_executeDef1 = true;
			//line 87 "C:\\Users\\909mm\\Desktop\\Work\\git\\icfpc2020\\haxe\\interp\\src\\interp\\Main.hx"
			if (( field != null )) 
			{
				//line 87 "C:\\Users\\909mm\\Desktop\\Work\\git\\icfpc2020\\haxe\\interp\\src\\interp\\Main.hx"
				switch (field.hashCode())
				{
					case 3552336:
					{
						//line 87 "C:\\Users\\909mm\\Desktop\\Work\\git\\icfpc2020\\haxe\\interp\\src\\interp\\Main.hx"
						if (field.equals("tail")) 
						{
							//line 87 "C:\\Users\\909mm\\Desktop\\Work\\git\\icfpc2020\\haxe\\interp\\src\\interp\\Main.hx"
							__temp_executeDef1 = false;
							//line 87 "C:\\Users\\909mm\\Desktop\\Work\\git\\icfpc2020\\haxe\\interp\\src\\interp\\Main.hx"
							this.tail = ((haxe.root.Array<haxe.root.Array<interp.Command>>) (value) );
							//line 87 "C:\\Users\\909mm\\Desktop\\Work\\git\\icfpc2020\\haxe\\interp\\src\\interp\\Main.hx"
							return value;
						}
						
						//line 87 "C:\\Users\\909mm\\Desktop\\Work\\git\\icfpc2020\\haxe\\interp\\src\\interp\\Main.hx"
						break;
					}
					
					
					case 100589:
					{
						//line 87 "C:\\Users\\909mm\\Desktop\\Work\\git\\icfpc2020\\haxe\\interp\\src\\interp\\Main.hx"
						if (field.equals("env")) 
						{
							//line 87 "C:\\Users\\909mm\\Desktop\\Work\\git\\icfpc2020\\haxe\\interp\\src\\interp\\Main.hx"
							__temp_executeDef1 = false;
							//line 87 "C:\\Users\\909mm\\Desktop\\Work\\git\\icfpc2020\\haxe\\interp\\src\\interp\\Main.hx"
							this.env = ((interp._Main.Environment) (value) );
							//line 87 "C:\\Users\\909mm\\Desktop\\Work\\git\\icfpc2020\\haxe\\interp\\src\\interp\\Main.hx"
							return value;
						}
						
						//line 87 "C:\\Users\\909mm\\Desktop\\Work\\git\\icfpc2020\\haxe\\interp\\src\\interp\\Main.hx"
						break;
					}
					
					
					case 94631196:
					{
						//line 87 "C:\\Users\\909mm\\Desktop\\Work\\git\\icfpc2020\\haxe\\interp\\src\\interp\\Main.hx"
						if (field.equals("child")) 
						{
							//line 87 "C:\\Users\\909mm\\Desktop\\Work\\git\\icfpc2020\\haxe\\interp\\src\\interp\\Main.hx"
							__temp_executeDef1 = false;
							//line 87 "C:\\Users\\909mm\\Desktop\\Work\\git\\icfpc2020\\haxe\\interp\\src\\interp\\Main.hx"
							this.child = ((interp._Main.Node) (value) );
							//line 87 "C:\\Users\\909mm\\Desktop\\Work\\git\\icfpc2020\\haxe\\interp\\src\\interp\\Main.hx"
							return value;
						}
						
						//line 87 "C:\\Users\\909mm\\Desktop\\Work\\git\\icfpc2020\\haxe\\interp\\src\\interp\\Main.hx"
						break;
					}
					
					
					case -1005512447:
					{
						//line 87 "C:\\Users\\909mm\\Desktop\\Work\\git\\icfpc2020\\haxe\\interp\\src\\interp\\Main.hx"
						if (field.equals("output")) 
						{
							//line 87 "C:\\Users\\909mm\\Desktop\\Work\\git\\icfpc2020\\haxe\\interp\\src\\interp\\Main.hx"
							__temp_executeDef1 = false;
							//line 87 "C:\\Users\\909mm\\Desktop\\Work\\git\\icfpc2020\\haxe\\interp\\src\\interp\\Main.hx"
							this.output = ((haxe.root.Array<interp.Command>) (value) );
							//line 87 "C:\\Users\\909mm\\Desktop\\Work\\git\\icfpc2020\\haxe\\interp\\src\\interp\\Main.hx"
							return value;
						}
						
						//line 87 "C:\\Users\\909mm\\Desktop\\Work\\git\\icfpc2020\\haxe\\interp\\src\\interp\\Main.hx"
						break;
					}
					
					
				}
				
			}
			
			//line 87 "C:\\Users\\909mm\\Desktop\\Work\\git\\icfpc2020\\haxe\\interp\\src\\interp\\Main.hx"
			if (__temp_executeDef1) 
			{
				//line 87 "C:\\Users\\909mm\\Desktop\\Work\\git\\icfpc2020\\haxe\\interp\\src\\interp\\Main.hx"
				return super.__hx_setField(field, value, handleProperties);
			}
			else
			{
				//line 87 "C:\\Users\\909mm\\Desktop\\Work\\git\\icfpc2020\\haxe\\interp\\src\\interp\\Main.hx"
				throw null;
			}
			
		}
		
	}
	
	
	@Override public java.lang.Object __hx_getField(java.lang.String field, boolean throwErrors, boolean isCheck, boolean handleProperties)
	{
		//line 87 "C:\\Users\\909mm\\Desktop\\Work\\git\\icfpc2020\\haxe\\interp\\src\\interp\\Main.hx"
		{
			//line 87 "C:\\Users\\909mm\\Desktop\\Work\\git\\icfpc2020\\haxe\\interp\\src\\interp\\Main.hx"
			boolean __temp_executeDef1 = true;
			//line 87 "C:\\Users\\909mm\\Desktop\\Work\\git\\icfpc2020\\haxe\\interp\\src\\interp\\Main.hx"
			if (( field != null )) 
			{
				//line 87 "C:\\Users\\909mm\\Desktop\\Work\\git\\icfpc2020\\haxe\\interp\\src\\interp\\Main.hx"
				switch (field.hashCode())
				{
					case 1987255061:
					{
						//line 87 "C:\\Users\\909mm\\Desktop\\Work\\git\\icfpc2020\\haxe\\interp\\src\\interp\\Main.hx"
						if (field.equals("getCommand")) 
						{
							//line 87 "C:\\Users\\909mm\\Desktop\\Work\\git\\icfpc2020\\haxe\\interp\\src\\interp\\Main.hx"
							__temp_executeDef1 = false;
							//line 87 "C:\\Users\\909mm\\Desktop\\Work\\git\\icfpc2020\\haxe\\interp\\src\\interp\\Main.hx"
							return ((haxe.lang.Function) (new haxe.lang.Closure(this, "getCommand")) );
						}
						
						//line 87 "C:\\Users\\909mm\\Desktop\\Work\\git\\icfpc2020\\haxe\\interp\\src\\interp\\Main.hx"
						break;
					}
					
					
					case 100589:
					{
						//line 87 "C:\\Users\\909mm\\Desktop\\Work\\git\\icfpc2020\\haxe\\interp\\src\\interp\\Main.hx"
						if (field.equals("env")) 
						{
							//line 87 "C:\\Users\\909mm\\Desktop\\Work\\git\\icfpc2020\\haxe\\interp\\src\\interp\\Main.hx"
							__temp_executeDef1 = false;
							//line 87 "C:\\Users\\909mm\\Desktop\\Work\\git\\icfpc2020\\haxe\\interp\\src\\interp\\Main.hx"
							return this.env;
						}
						
						//line 87 "C:\\Users\\909mm\\Desktop\\Work\\git\\icfpc2020\\haxe\\interp\\src\\interp\\Main.hx"
						break;
					}
					
					
					case 96417:
					{
						//line 87 "C:\\Users\\909mm\\Desktop\\Work\\git\\icfpc2020\\haxe\\interp\\src\\interp\\Main.hx"
						if (field.equals("add")) 
						{
							//line 87 "C:\\Users\\909mm\\Desktop\\Work\\git\\icfpc2020\\haxe\\interp\\src\\interp\\Main.hx"
							__temp_executeDef1 = false;
							//line 87 "C:\\Users\\909mm\\Desktop\\Work\\git\\icfpc2020\\haxe\\interp\\src\\interp\\Main.hx"
							return ((haxe.lang.Function) (new haxe.lang.Closure(this, "add")) );
						}
						
						//line 87 "C:\\Users\\909mm\\Desktop\\Work\\git\\icfpc2020\\haxe\\interp\\src\\interp\\Main.hx"
						break;
					}
					
					
					case -1005512447:
					{
						//line 87 "C:\\Users\\909mm\\Desktop\\Work\\git\\icfpc2020\\haxe\\interp\\src\\interp\\Main.hx"
						if (field.equals("output")) 
						{
							//line 87 "C:\\Users\\909mm\\Desktop\\Work\\git\\icfpc2020\\haxe\\interp\\src\\interp\\Main.hx"
							__temp_executeDef1 = false;
							//line 87 "C:\\Users\\909mm\\Desktop\\Work\\git\\icfpc2020\\haxe\\interp\\src\\interp\\Main.hx"
							return this.output;
						}
						
						//line 87 "C:\\Users\\909mm\\Desktop\\Work\\git\\icfpc2020\\haxe\\interp\\src\\interp\\Main.hx"
						break;
					}
					
					
					case 3552336:
					{
						//line 87 "C:\\Users\\909mm\\Desktop\\Work\\git\\icfpc2020\\haxe\\interp\\src\\interp\\Main.hx"
						if (field.equals("tail")) 
						{
							//line 87 "C:\\Users\\909mm\\Desktop\\Work\\git\\icfpc2020\\haxe\\interp\\src\\interp\\Main.hx"
							__temp_executeDef1 = false;
							//line 87 "C:\\Users\\909mm\\Desktop\\Work\\git\\icfpc2020\\haxe\\interp\\src\\interp\\Main.hx"
							return this.tail;
						}
						
						//line 87 "C:\\Users\\909mm\\Desktop\\Work\\git\\icfpc2020\\haxe\\interp\\src\\interp\\Main.hx"
						break;
					}
					
					
					case 94631196:
					{
						//line 87 "C:\\Users\\909mm\\Desktop\\Work\\git\\icfpc2020\\haxe\\interp\\src\\interp\\Main.hx"
						if (field.equals("child")) 
						{
							//line 87 "C:\\Users\\909mm\\Desktop\\Work\\git\\icfpc2020\\haxe\\interp\\src\\interp\\Main.hx"
							__temp_executeDef1 = false;
							//line 87 "C:\\Users\\909mm\\Desktop\\Work\\git\\icfpc2020\\haxe\\interp\\src\\interp\\Main.hx"
							return this.child;
						}
						
						//line 87 "C:\\Users\\909mm\\Desktop\\Work\\git\\icfpc2020\\haxe\\interp\\src\\interp\\Main.hx"
						break;
					}
					
					
				}
				
			}
			
			//line 87 "C:\\Users\\909mm\\Desktop\\Work\\git\\icfpc2020\\haxe\\interp\\src\\interp\\Main.hx"
			if (__temp_executeDef1) 
			{
				//line 87 "C:\\Users\\909mm\\Desktop\\Work\\git\\icfpc2020\\haxe\\interp\\src\\interp\\Main.hx"
				return super.__hx_getField(field, throwErrors, isCheck, handleProperties);
			}
			else
			{
				//line 87 "C:\\Users\\909mm\\Desktop\\Work\\git\\icfpc2020\\haxe\\interp\\src\\interp\\Main.hx"
				throw null;
			}
			
		}
		
	}
	
	
	@Override public java.lang.Object __hx_invokeField(java.lang.String field, java.lang.Object[] dynargs)
	{
		//line 87 "C:\\Users\\909mm\\Desktop\\Work\\git\\icfpc2020\\haxe\\interp\\src\\interp\\Main.hx"
		{
			//line 87 "C:\\Users\\909mm\\Desktop\\Work\\git\\icfpc2020\\haxe\\interp\\src\\interp\\Main.hx"
			boolean __temp_executeDef1 = true;
			//line 87 "C:\\Users\\909mm\\Desktop\\Work\\git\\icfpc2020\\haxe\\interp\\src\\interp\\Main.hx"
			if (( field != null )) 
			{
				//line 87 "C:\\Users\\909mm\\Desktop\\Work\\git\\icfpc2020\\haxe\\interp\\src\\interp\\Main.hx"
				switch (field.hashCode())
				{
					case 1987255061:
					{
						//line 87 "C:\\Users\\909mm\\Desktop\\Work\\git\\icfpc2020\\haxe\\interp\\src\\interp\\Main.hx"
						if (field.equals("getCommand")) 
						{
							//line 87 "C:\\Users\\909mm\\Desktop\\Work\\git\\icfpc2020\\haxe\\interp\\src\\interp\\Main.hx"
							__temp_executeDef1 = false;
							//line 87 "C:\\Users\\909mm\\Desktop\\Work\\git\\icfpc2020\\haxe\\interp\\src\\interp\\Main.hx"
							return this.getCommand(haxe.lang.Runtime.toString(dynargs[0]));
						}
						
						//line 87 "C:\\Users\\909mm\\Desktop\\Work\\git\\icfpc2020\\haxe\\interp\\src\\interp\\Main.hx"
						break;
					}
					
					
					case 96417:
					{
						//line 87 "C:\\Users\\909mm\\Desktop\\Work\\git\\icfpc2020\\haxe\\interp\\src\\interp\\Main.hx"
						if (field.equals("add")) 
						{
							//line 87 "C:\\Users\\909mm\\Desktop\\Work\\git\\icfpc2020\\haxe\\interp\\src\\interp\\Main.hx"
							__temp_executeDef1 = false;
							//line 87 "C:\\Users\\909mm\\Desktop\\Work\\git\\icfpc2020\\haxe\\interp\\src\\interp\\Main.hx"
							this.add(haxe.lang.Runtime.toString(dynargs[0]));
						}
						
						//line 87 "C:\\Users\\909mm\\Desktop\\Work\\git\\icfpc2020\\haxe\\interp\\src\\interp\\Main.hx"
						break;
					}
					
					
				}
				
			}
			
			//line 87 "C:\\Users\\909mm\\Desktop\\Work\\git\\icfpc2020\\haxe\\interp\\src\\interp\\Main.hx"
			if (__temp_executeDef1) 
			{
				//line 87 "C:\\Users\\909mm\\Desktop\\Work\\git\\icfpc2020\\haxe\\interp\\src\\interp\\Main.hx"
				return super.__hx_invokeField(field, dynargs);
			}
			
		}
		
		//line 87 "C:\\Users\\909mm\\Desktop\\Work\\git\\icfpc2020\\haxe\\interp\\src\\interp\\Main.hx"
		return null;
	}
	
	
	@Override public void __hx_getFields(haxe.root.Array<java.lang.String> baseArr)
	{
		//line 87 "C:\\Users\\909mm\\Desktop\\Work\\git\\icfpc2020\\haxe\\interp\\src\\interp\\Main.hx"
		baseArr.push("tail");
		//line 87 "C:\\Users\\909mm\\Desktop\\Work\\git\\icfpc2020\\haxe\\interp\\src\\interp\\Main.hx"
		baseArr.push("child");
		//line 87 "C:\\Users\\909mm\\Desktop\\Work\\git\\icfpc2020\\haxe\\interp\\src\\interp\\Main.hx"
		baseArr.push("output");
		//line 87 "C:\\Users\\909mm\\Desktop\\Work\\git\\icfpc2020\\haxe\\interp\\src\\interp\\Main.hx"
		baseArr.push("env");
		//line 87 "C:\\Users\\909mm\\Desktop\\Work\\git\\icfpc2020\\haxe\\interp\\src\\interp\\Main.hx"
		super.__hx_getFields(baseArr);
	}
	
	
}


