// Generated by Haxe 4.1.1
package interp;

import haxe.root.*;

@SuppressWarnings(value={"rawtypes", "unchecked"})
public class ValueTools extends haxe.lang.HxObject
{
	public ValueTools(haxe.lang.EmptyObject empty)
	{
	}
	
	
	public ValueTools()
	{
		//line 3 "C:\\Users\\909mm\\Desktop\\Work\\git\\icfpc2020\\haxe\\interp\\src\\interp\\ValueTools.hx"
		interp.ValueTools.__hx_ctor_interp_ValueTools(this);
	}
	
	
	protected static void __hx_ctor_interp_ValueTools(interp.ValueTools __hx_this)
	{
	}
	
	
	public static java.lang.String toString(interp.Value token)
	{
		//line 7 "C:\\Users\\909mm\\Desktop\\Work\\git\\icfpc2020\\haxe\\interp\\src\\interp\\ValueTools.hx"
		switch (token.index)
		{
			case 0:
			{
				//line 20 "C:\\Users\\909mm\\Desktop\\Work\\git\\icfpc2020\\haxe\\interp\\src\\interp\\ValueTools.hx"
				java.math.BigInteger i = ((java.math.BigInteger) (token.params[0]) );
				//line 20 "C:\\Users\\909mm\\Desktop\\Work\\git\\icfpc2020\\haxe\\interp\\src\\interp\\ValueTools.hx"
				return i.toString();
			}
			
			
			case 1:
			{
				//line 9 "C:\\Users\\909mm\\Desktop\\Work\\git\\icfpc2020\\haxe\\interp\\src\\interp\\ValueTools.hx"
				interp.LinkValue args = ((interp.LinkValue) (token.params[1]) );
				//line 9 "C:\\Users\\909mm\\Desktop\\Work\\git\\icfpc2020\\haxe\\interp\\src\\interp\\ValueTools.hx"
				java.lang.String u = haxe.lang.Runtime.toString(token.params[0]);
				//line 10 "C:\\Users\\909mm\\Desktop\\Work\\git\\icfpc2020\\haxe\\interp\\src\\interp\\ValueTools.hx"
				java.lang.String head = "";
				//line 11 "C:\\Users\\909mm\\Desktop\\Work\\git\\icfpc2020\\haxe\\interp\\src\\interp\\ValueTools.hx"
				java.lang.String tail = "";
				//line 12 "C:\\Users\\909mm\\Desktop\\Work\\git\\icfpc2020\\haxe\\interp\\src\\interp\\ValueTools.hx"
				while (( args != null ))
				{
					//line 14 "C:\\Users\\909mm\\Desktop\\Work\\git\\icfpc2020\\haxe\\interp\\src\\interp\\ValueTools.hx"
					head += "ap ";
					//line 15 "C:\\Users\\909mm\\Desktop\\Work\\git\\icfpc2020\\haxe\\interp\\src\\interp\\ValueTools.hx"
					tail = ( ( " " + interp.ValueTools.toString(args.value) ) + tail );
					//line 16 "C:\\Users\\909mm\\Desktop\\Work\\git\\icfpc2020\\haxe\\interp\\src\\interp\\ValueTools.hx"
					args = args.child;
				}
				
				//line 18 "C:\\Users\\909mm\\Desktop\\Work\\git\\icfpc2020\\haxe\\interp\\src\\interp\\ValueTools.hx"
				return ( ( head + u.toString() ) + tail );
			}
			
			
			case 2:
			{
				//line 21 "C:\\Users\\909mm\\Desktop\\Work\\git\\icfpc2020\\haxe\\interp\\src\\interp\\ValueTools.hx"
				interp.LinkValue args1 = ((interp.LinkValue) (token.params[1]) );
				//line 21 "C:\\Users\\909mm\\Desktop\\Work\\git\\icfpc2020\\haxe\\interp\\src\\interp\\ValueTools.hx"
				java.lang.String func = haxe.lang.Runtime.toString(token.params[0]);
				//line 22 "C:\\Users\\909mm\\Desktop\\Work\\git\\icfpc2020\\haxe\\interp\\src\\interp\\ValueTools.hx"
				java.lang.String head1 = "";
				//line 23 "C:\\Users\\909mm\\Desktop\\Work\\git\\icfpc2020\\haxe\\interp\\src\\interp\\ValueTools.hx"
				java.lang.String tail1 = "";
				//line 24 "C:\\Users\\909mm\\Desktop\\Work\\git\\icfpc2020\\haxe\\interp\\src\\interp\\ValueTools.hx"
				while (( args1 != null ))
				{
					//line 26 "C:\\Users\\909mm\\Desktop\\Work\\git\\icfpc2020\\haxe\\interp\\src\\interp\\ValueTools.hx"
					head1 += "ap ";
					//line 27 "C:\\Users\\909mm\\Desktop\\Work\\git\\icfpc2020\\haxe\\interp\\src\\interp\\ValueTools.hx"
					tail1 = ( ( " " + interp.ValueTools.toString(args1.value) ) + tail1 );
					//line 28 "C:\\Users\\909mm\\Desktop\\Work\\git\\icfpc2020\\haxe\\interp\\src\\interp\\ValueTools.hx"
					args1 = args1.child;
				}
				
				//line 30 "C:\\Users\\909mm\\Desktop\\Work\\git\\icfpc2020\\haxe\\interp\\src\\interp\\ValueTools.hx"
				return ( ( head1 + interp._Function.Function_Impl_.toString(func) ) + tail1 );
			}
			
			
		}
		
		//line 5 "C:\\Users\\909mm\\Desktop\\Work\\git\\icfpc2020\\haxe\\interp\\src\\interp\\ValueTools.hx"
		return null;
	}
	
	
	public static java.math.BigInteger toInt(interp.Value value)
	{
		//line 35 "C:\\Users\\909mm\\Desktop\\Work\\git\\icfpc2020\\haxe\\interp\\src\\interp\\ValueTools.hx"
		switch (value.index)
		{
			case 0:
			{
				//line 37 "C:\\Users\\909mm\\Desktop\\Work\\git\\icfpc2020\\haxe\\interp\\src\\interp\\ValueTools.hx"
				java.math.BigInteger i = ((java.math.BigInteger) (value.params[0]) );
				//line 37 "C:\\Users\\909mm\\Desktop\\Work\\git\\icfpc2020\\haxe\\interp\\src\\interp\\ValueTools.hx"
				return i;
			}
			
			
			case 1:
			{
				//line 38 "C:\\Users\\909mm\\Desktop\\Work\\git\\icfpc2020\\haxe\\interp\\src\\interp\\ValueTools.hx"
				interp.LinkValue args = ((interp.LinkValue) (value.params[1]) );
				//line 38 "C:\\Users\\909mm\\Desktop\\Work\\git\\icfpc2020\\haxe\\interp\\src\\interp\\ValueTools.hx"
				java.lang.String u = haxe.lang.Runtime.toString(value.params[0]);
				//line 38 "C:\\Users\\909mm\\Desktop\\Work\\git\\icfpc2020\\haxe\\interp\\src\\interp\\ValueTools.hx"
				throw ((java.lang.RuntimeException) (haxe.Exception.thrown(new interp.TypeError(haxe.lang.Runtime.toString("unkown is not int")))) );
			}
			
			
			case 2:
			{
				//line 39 "C:\\Users\\909mm\\Desktop\\Work\\git\\icfpc2020\\haxe\\interp\\src\\interp\\ValueTools.hx"
				interp.LinkValue args1 = ((interp.LinkValue) (value.params[1]) );
				//line 39 "C:\\Users\\909mm\\Desktop\\Work\\git\\icfpc2020\\haxe\\interp\\src\\interp\\ValueTools.hx"
				java.lang.String func = haxe.lang.Runtime.toString(value.params[0]);
				//line 39 "C:\\Users\\909mm\\Desktop\\Work\\git\\icfpc2020\\haxe\\interp\\src\\interp\\ValueTools.hx"
				throw ((java.lang.RuntimeException) (haxe.Exception.thrown(new interp.TypeError(haxe.lang.Runtime.toString("func is not func")))) );
			}
			
			
		}
		
		//line 33 "C:\\Users\\909mm\\Desktop\\Work\\git\\icfpc2020\\haxe\\interp\\src\\interp\\ValueTools.hx"
		return null;
	}
	
	
	public static interp.Value ap(interp.Value value, interp.Value arg)
	{
		//line 44 "C:\\Users\\909mm\\Desktop\\Work\\git\\icfpc2020\\haxe\\interp\\src\\interp\\ValueTools.hx"
		switch (value.index)
		{
			case 0:
			{
				//line 46 "C:\\Users\\909mm\\Desktop\\Work\\git\\icfpc2020\\haxe\\interp\\src\\interp\\ValueTools.hx"
				java.math.BigInteger i = ((java.math.BigInteger) (value.params[0]) );
				//line 47 "C:\\Users\\909mm\\Desktop\\Work\\git\\icfpc2020\\haxe\\interp\\src\\interp\\ValueTools.hx"
				throw ((java.lang.RuntimeException) (haxe.Exception.thrown(( "invalid ap int:" + haxe.root.Std.string(i) ))) );
			}
			
			
			case 1:
			{
				//line 60 "C:\\Users\\909mm\\Desktop\\Work\\git\\icfpc2020\\haxe\\interp\\src\\interp\\ValueTools.hx"
				interp.LinkValue link = ((interp.LinkValue) (value.params[1]) );
				//line 60 "C:\\Users\\909mm\\Desktop\\Work\\git\\icfpc2020\\haxe\\interp\\src\\interp\\ValueTools.hx"
				java.lang.String str = haxe.lang.Runtime.toString(value.params[0]);
				//line 61 "C:\\Users\\909mm\\Desktop\\Work\\git\\icfpc2020\\haxe\\interp\\src\\interp\\ValueTools.hx"
				return interp.Value.Unknown(str, new interp.LinkValue(arg, link));
			}
			
			
			case 2:
			{
				//line 49 "C:\\Users\\909mm\\Desktop\\Work\\git\\icfpc2020\\haxe\\interp\\src\\interp\\ValueTools.hx"
				interp.LinkValue link1 = ((interp.LinkValue) (value.params[1]) );
				//line 49 "C:\\Users\\909mm\\Desktop\\Work\\git\\icfpc2020\\haxe\\interp\\src\\interp\\ValueTools.hx"
				java.lang.String func = haxe.lang.Runtime.toString(value.params[0]);
				//line 50 "C:\\Users\\909mm\\Desktop\\Work\\git\\icfpc2020\\haxe\\interp\\src\\interp\\ValueTools.hx"
				interp.LinkValue link2 = new interp.LinkValue(arg, link1);
				//line 51 "C:\\Users\\909mm\\Desktop\\Work\\git\\icfpc2020\\haxe\\interp\\src\\interp\\ValueTools.hx"
				if (( interp._Function.Function_Impl_.getRequiredSize(func) == link2.size )) 
				{
					//line 53 "C:\\Users\\909mm\\Desktop\\Work\\git\\icfpc2020\\haxe\\interp\\src\\interp\\ValueTools.hx"
					return interp._Function.Function_Impl_.execute(func, link2);
				}
				else
				{
					//line 57 "C:\\Users\\909mm\\Desktop\\Work\\git\\icfpc2020\\haxe\\interp\\src\\interp\\ValueTools.hx"
					return interp.Value.Func(func, link2);
				}
				
			}
			
			
		}
		
		//line 42 "C:\\Users\\909mm\\Desktop\\Work\\git\\icfpc2020\\haxe\\interp\\src\\interp\\ValueTools.hx"
		return null;
	}
	
	
	public static interp.Value add(interp.Value x0, interp.Value x1)
	{
		//line 68 "C:\\Users\\909mm\\Desktop\\Work\\git\\icfpc2020\\haxe\\interp\\src\\interp\\ValueTools.hx"
		switch (x0.index)
		{
			case 0:
			{
				//line 76 "C:\\Users\\909mm\\Desktop\\Work\\git\\icfpc2020\\haxe\\interp\\src\\interp\\ValueTools.hx"
				java.math.BigInteger _g = ((java.math.BigInteger) (x0.params[0]) );
				//line 70 "C:\\Users\\909mm\\Desktop\\Work\\git\\icfpc2020\\haxe\\interp\\src\\interp\\ValueTools.hx"
				interp.Value x11 = x1;
				//line 70 "C:\\Users\\909mm\\Desktop\\Work\\git\\icfpc2020\\haxe\\interp\\src\\interp\\ValueTools.hx"
				java.math.BigInteger i = _g;
				//line 68 "C:\\Users\\909mm\\Desktop\\Work\\git\\icfpc2020\\haxe\\interp\\src\\interp\\ValueTools.hx"
				if (i.equals(((java.lang.Object) (java.math.BigInteger.ZERO) ))) 
				{
					//line 71 "C:\\Users\\909mm\\Desktop\\Work\\git\\icfpc2020\\haxe\\interp\\src\\interp\\ValueTools.hx"
					return x11;
				}
				else
				{
					//line 68 "C:\\Users\\909mm\\Desktop\\Work\\git\\icfpc2020\\haxe\\interp\\src\\interp\\ValueTools.hx"
					switch (x1.index)
					{
						case 0:
						{
							//line 76 "C:\\Users\\909mm\\Desktop\\Work\\git\\icfpc2020\\haxe\\interp\\src\\interp\\ValueTools.hx"
							java.math.BigInteger _g1 = ((java.math.BigInteger) (x1.params[0]) );
							//line 73 "C:\\Users\\909mm\\Desktop\\Work\\git\\icfpc2020\\haxe\\interp\\src\\interp\\ValueTools.hx"
							java.math.BigInteger i1 = _g1;
							//line 73 "C:\\Users\\909mm\\Desktop\\Work\\git\\icfpc2020\\haxe\\interp\\src\\interp\\ValueTools.hx"
							interp.Value x01 = x0;
							//line 73 "C:\\Users\\909mm\\Desktop\\Work\\git\\icfpc2020\\haxe\\interp\\src\\interp\\ValueTools.hx"
							if (i1.equals(((java.lang.Object) (java.math.BigInteger.ZERO) ))) 
							{
								//line 74 "C:\\Users\\909mm\\Desktop\\Work\\git\\icfpc2020\\haxe\\interp\\src\\interp\\ValueTools.hx"
								return x01;
							}
							else
							{
								//line 76 "C:\\Users\\909mm\\Desktop\\Work\\git\\icfpc2020\\haxe\\interp\\src\\interp\\ValueTools.hx"
								java.math.BigInteger x02 = _g;
								//line 76 "C:\\Users\\909mm\\Desktop\\Work\\git\\icfpc2020\\haxe\\interp\\src\\interp\\ValueTools.hx"
								java.math.BigInteger x12 = _g1;
								//line 77 "C:\\Users\\909mm\\Desktop\\Work\\git\\icfpc2020\\haxe\\interp\\src\\interp\\ValueTools.hx"
								return interp.Value.Int(x02.add(((java.math.BigInteger) (x12) )));
							}
							
						}
						
						
						default:
						{
							//line 80 "C:\\Users\\909mm\\Desktop\\Work\\git\\icfpc2020\\haxe\\interp\\src\\interp\\ValueTools.hx"
							return interp.Value.Func(haxe.lang.Runtime.toString("add"), interp.LinkValue.create2(x0, x1));
						}
						
					}
					
				}
				
			}
			
			
			default:
			{
				//line 68 "C:\\Users\\909mm\\Desktop\\Work\\git\\icfpc2020\\haxe\\interp\\src\\interp\\ValueTools.hx"
				switch (x1.index)
				{
					case 0:
					{
						//line 73 "C:\\Users\\909mm\\Desktop\\Work\\git\\icfpc2020\\haxe\\interp\\src\\interp\\ValueTools.hx"
						java.math.BigInteger i2 = ((java.math.BigInteger) (x1.params[0]) );
						//line 73 "C:\\Users\\909mm\\Desktop\\Work\\git\\icfpc2020\\haxe\\interp\\src\\interp\\ValueTools.hx"
						interp.Value x03 = x0;
						//line 73 "C:\\Users\\909mm\\Desktop\\Work\\git\\icfpc2020\\haxe\\interp\\src\\interp\\ValueTools.hx"
						if (i2.equals(((java.lang.Object) (java.math.BigInteger.ZERO) ))) 
						{
							//line 74 "C:\\Users\\909mm\\Desktop\\Work\\git\\icfpc2020\\haxe\\interp\\src\\interp\\ValueTools.hx"
							return x03;
						}
						else
						{
							//line 80 "C:\\Users\\909mm\\Desktop\\Work\\git\\icfpc2020\\haxe\\interp\\src\\interp\\ValueTools.hx"
							return interp.Value.Func(haxe.lang.Runtime.toString("add"), interp.LinkValue.create2(x0, x1));
						}
						
					}
					
					
					default:
					{
						//line 80 "C:\\Users\\909mm\\Desktop\\Work\\git\\icfpc2020\\haxe\\interp\\src\\interp\\ValueTools.hx"
						return interp.Value.Func(haxe.lang.Runtime.toString("add"), interp.LinkValue.create2(x0, x1));
					}
					
				}
				
			}
			
		}
		
	}
	
	
	public static int eq(interp.Value x0, interp.Value x1)
	{
		//line 86 "C:\\Users\\909mm\\Desktop\\Work\\git\\icfpc2020\\haxe\\interp\\src\\interp\\ValueTools.hx"
		switch (x0.index)
		{
			case 0:
			{
				//line 94 "C:\\Users\\909mm\\Desktop\\Work\\git\\icfpc2020\\haxe\\interp\\src\\interp\\ValueTools.hx"
				java.math.BigInteger i0 = ((java.math.BigInteger) (x0.params[0]) );
				//line 95 "C:\\Users\\909mm\\Desktop\\Work\\git\\icfpc2020\\haxe\\interp\\src\\interp\\ValueTools.hx"
				switch (x1.index)
				{
					case 0:
					{
						//line 97 "C:\\Users\\909mm\\Desktop\\Work\\git\\icfpc2020\\haxe\\interp\\src\\interp\\ValueTools.hx"
						java.math.BigInteger i1 = ((java.math.BigInteger) (x1.params[0]) );
						//line 97 "C:\\Users\\909mm\\Desktop\\Work\\git\\icfpc2020\\haxe\\interp\\src\\interp\\ValueTools.hx"
						if (i0.equals(((java.lang.Object) (i1) ))) 
						{
							//line 98 "C:\\Users\\909mm\\Desktop\\Work\\git\\icfpc2020\\haxe\\interp\\src\\interp\\ValueTools.hx"
							return ((int) (0) );
						}
						else
						{
							//line 101 "C:\\Users\\909mm\\Desktop\\Work\\git\\icfpc2020\\haxe\\interp\\src\\interp\\ValueTools.hx"
							return ((int) (1) );
						}
						
					}
					
					
					default:
					{
						//line 104 "C:\\Users\\909mm\\Desktop\\Work\\git\\icfpc2020\\haxe\\interp\\src\\interp\\ValueTools.hx"
						return ((int) (2) );
					}
					
				}
				
			}
			
			
			case 1:
			{
				//line 91 "C:\\Users\\909mm\\Desktop\\Work\\git\\icfpc2020\\haxe\\interp\\src\\interp\\ValueTools.hx"
				interp.LinkValue args0 = ((interp.LinkValue) (x0.params[1]) );
				//line 91 "C:\\Users\\909mm\\Desktop\\Work\\git\\icfpc2020\\haxe\\interp\\src\\interp\\ValueTools.hx"
				java.lang.String string0 = haxe.lang.Runtime.toString(x0.params[0]);
				//line 92 "C:\\Users\\909mm\\Desktop\\Work\\git\\icfpc2020\\haxe\\interp\\src\\interp\\ValueTools.hx"
				return ((int) (2) );
			}
			
			
			case 2:
			{
				//line 88 "C:\\Users\\909mm\\Desktop\\Work\\git\\icfpc2020\\haxe\\interp\\src\\interp\\ValueTools.hx"
				interp.LinkValue args01 = ((interp.LinkValue) (x0.params[1]) );
				//line 88 "C:\\Users\\909mm\\Desktop\\Work\\git\\icfpc2020\\haxe\\interp\\src\\interp\\ValueTools.hx"
				java.lang.String func0 = haxe.lang.Runtime.toString(x0.params[0]);
				//line 89 "C:\\Users\\909mm\\Desktop\\Work\\git\\icfpc2020\\haxe\\interp\\src\\interp\\ValueTools.hx"
				return ((int) (2) );
			}
			
			
		}
		
		//line 84 "C:\\Users\\909mm\\Desktop\\Work\\git\\icfpc2020\\haxe\\interp\\src\\interp\\ValueTools.hx"
		return 0;
	}
	
	
}


