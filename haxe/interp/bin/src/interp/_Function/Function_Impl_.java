// Generated by Haxe 4.1.1
package interp._Function;

import haxe.root.*;

@SuppressWarnings(value={"rawtypes", "unchecked"})
public final class Function_Impl_
{
	static
	{
		//line 7 "C:\\Users\\909mm\\Desktop\\Work\\git\\icfpc2020\\haxe\\interp\\src\\interp\\Function.hx"
		interp._Function.Function_Impl_.inc = haxe.lang.Runtime.toString("inc");
		//line 8 "C:\\Users\\909mm\\Desktop\\Work\\git\\icfpc2020\\haxe\\interp\\src\\interp\\Function.hx"
		interp._Function.Function_Impl_.dec = haxe.lang.Runtime.toString("dec");
		//line 9 "C:\\Users\\909mm\\Desktop\\Work\\git\\icfpc2020\\haxe\\interp\\src\\interp\\Function.hx"
		interp._Function.Function_Impl_.neg = haxe.lang.Runtime.toString("neg");
		//line 10 "C:\\Users\\909mm\\Desktop\\Work\\git\\icfpc2020\\haxe\\interp\\src\\interp\\Function.hx"
		interp._Function.Function_Impl_.add = haxe.lang.Runtime.toString("add");
		//line 11 "C:\\Users\\909mm\\Desktop\\Work\\git\\icfpc2020\\haxe\\interp\\src\\interp\\Function.hx"
		interp._Function.Function_Impl_.mul = haxe.lang.Runtime.toString("mul");
		//line 12 "C:\\Users\\909mm\\Desktop\\Work\\git\\icfpc2020\\haxe\\interp\\src\\interp\\Function.hx"
		interp._Function.Function_Impl_.lt = haxe.lang.Runtime.toString("lt");
		//line 13 "C:\\Users\\909mm\\Desktop\\Work\\git\\icfpc2020\\haxe\\interp\\src\\interp\\Function.hx"
		interp._Function.Function_Impl_.eq = haxe.lang.Runtime.toString("eq");
		//line 14 "C:\\Users\\909mm\\Desktop\\Work\\git\\icfpc2020\\haxe\\interp\\src\\interp\\Function.hx"
		interp._Function.Function_Impl_.s = haxe.lang.Runtime.toString("s");
		//line 15 "C:\\Users\\909mm\\Desktop\\Work\\git\\icfpc2020\\haxe\\interp\\src\\interp\\Function.hx"
		interp._Function.Function_Impl_.c = haxe.lang.Runtime.toString("c");
		//line 16 "C:\\Users\\909mm\\Desktop\\Work\\git\\icfpc2020\\haxe\\interp\\src\\interp\\Function.hx"
		interp._Function.Function_Impl_.b = haxe.lang.Runtime.toString("b");
	}
	
	public static java.lang.String inc;
	
	public static java.lang.String dec;
	
	public static java.lang.String neg;
	
	public static java.lang.String add;
	
	public static java.lang.String mul;
	
	public static java.lang.String lt;
	
	public static java.lang.String eq;
	
	public static java.lang.String s;
	
	public static java.lang.String c;
	
	public static java.lang.String b;
	
	public static int getRequiredSize(java.lang.String this1)
	{
		//line 20 "C:\\Users\\909mm\\Desktop\\Work\\git\\icfpc2020\\haxe\\interp\\src\\interp\\Function.hx"
		{
			//line 20 "C:\\Users\\909mm\\Desktop\\Work\\git\\icfpc2020\\haxe\\interp\\src\\interp\\Function.hx"
			java.lang.String __temp_svar1 = (haxe.lang.Runtime.toString(this1));
			//line 20 "C:\\Users\\909mm\\Desktop\\Work\\git\\icfpc2020\\haxe\\interp\\src\\interp\\Function.hx"
			if (( __temp_svar1 != null )) 
			{
				//line 20 "C:\\Users\\909mm\\Desktop\\Work\\git\\icfpc2020\\haxe\\interp\\src\\interp\\Function.hx"
				switch (__temp_svar1.hashCode())
				{
					case 96417:
					{
						//line 25 "C:\\Users\\909mm\\Desktop\\Work\\git\\icfpc2020\\haxe\\interp\\src\\interp\\Function.hx"
						if (__temp_svar1.equals("add")) 
						{
							//line 25 "C:\\Users\\909mm\\Desktop\\Work\\git\\icfpc2020\\haxe\\interp\\src\\interp\\Function.hx"
							return 2;
						}
						
						//line 25 "C:\\Users\\909mm\\Desktop\\Work\\git\\icfpc2020\\haxe\\interp\\src\\interp\\Function.hx"
						break;
					}
					
					
					case 115:
					{
						//line 29 "C:\\Users\\909mm\\Desktop\\Work\\git\\icfpc2020\\haxe\\interp\\src\\interp\\Function.hx"
						if (__temp_svar1.equals("s")) 
						{
							//line 29 "C:\\Users\\909mm\\Desktop\\Work\\git\\icfpc2020\\haxe\\interp\\src\\interp\\Function.hx"
							return 3;
						}
						
						//line 29 "C:\\Users\\909mm\\Desktop\\Work\\git\\icfpc2020\\haxe\\interp\\src\\interp\\Function.hx"
						break;
					}
					
					
					case 98:
					{
						//line 31 "C:\\Users\\909mm\\Desktop\\Work\\git\\icfpc2020\\haxe\\interp\\src\\interp\\Function.hx"
						if (__temp_svar1.equals("b")) 
						{
							//line 31 "C:\\Users\\909mm\\Desktop\\Work\\git\\icfpc2020\\haxe\\interp\\src\\interp\\Function.hx"
							return 3;
						}
						
						//line 31 "C:\\Users\\909mm\\Desktop\\Work\\git\\icfpc2020\\haxe\\interp\\src\\interp\\Function.hx"
						break;
					}
					
					
					case 108944:
					{
						//line 24 "C:\\Users\\909mm\\Desktop\\Work\\git\\icfpc2020\\haxe\\interp\\src\\interp\\Function.hx"
						if (__temp_svar1.equals("neg")) 
						{
							//line 24 "C:\\Users\\909mm\\Desktop\\Work\\git\\icfpc2020\\haxe\\interp\\src\\interp\\Function.hx"
							return 1;
						}
						
						//line 24 "C:\\Users\\909mm\\Desktop\\Work\\git\\icfpc2020\\haxe\\interp\\src\\interp\\Function.hx"
						break;
					}
					
					
					case 99:
					{
						//line 30 "C:\\Users\\909mm\\Desktop\\Work\\git\\icfpc2020\\haxe\\interp\\src\\interp\\Function.hx"
						if (__temp_svar1.equals("c")) 
						{
							//line 30 "C:\\Users\\909mm\\Desktop\\Work\\git\\icfpc2020\\haxe\\interp\\src\\interp\\Function.hx"
							return 3;
						}
						
						//line 30 "C:\\Users\\909mm\\Desktop\\Work\\git\\icfpc2020\\haxe\\interp\\src\\interp\\Function.hx"
						break;
					}
					
					
					case 108484:
					{
						//line 26 "C:\\Users\\909mm\\Desktop\\Work\\git\\icfpc2020\\haxe\\interp\\src\\interp\\Function.hx"
						if (__temp_svar1.equals("mul")) 
						{
							//line 26 "C:\\Users\\909mm\\Desktop\\Work\\git\\icfpc2020\\haxe\\interp\\src\\interp\\Function.hx"
							return 2;
						}
						
						//line 26 "C:\\Users\\909mm\\Desktop\\Work\\git\\icfpc2020\\haxe\\interp\\src\\interp\\Function.hx"
						break;
					}
					
					
					case 99330:
					{
						//line 23 "C:\\Users\\909mm\\Desktop\\Work\\git\\icfpc2020\\haxe\\interp\\src\\interp\\Function.hx"
						if (__temp_svar1.equals("dec")) 
						{
							//line 23 "C:\\Users\\909mm\\Desktop\\Work\\git\\icfpc2020\\haxe\\interp\\src\\interp\\Function.hx"
							return 1;
						}
						
						//line 23 "C:\\Users\\909mm\\Desktop\\Work\\git\\icfpc2020\\haxe\\interp\\src\\interp\\Function.hx"
						break;
					}
					
					
					case 3464:
					{
						//line 27 "C:\\Users\\909mm\\Desktop\\Work\\git\\icfpc2020\\haxe\\interp\\src\\interp\\Function.hx"
						if (__temp_svar1.equals("lt")) 
						{
							//line 27 "C:\\Users\\909mm\\Desktop\\Work\\git\\icfpc2020\\haxe\\interp\\src\\interp\\Function.hx"
							return 2;
						}
						
						//line 27 "C:\\Users\\909mm\\Desktop\\Work\\git\\icfpc2020\\haxe\\interp\\src\\interp\\Function.hx"
						break;
					}
					
					
					case 3244:
					{
						//line 28 "C:\\Users\\909mm\\Desktop\\Work\\git\\icfpc2020\\haxe\\interp\\src\\interp\\Function.hx"
						if (__temp_svar1.equals("eq")) 
						{
							//line 28 "C:\\Users\\909mm\\Desktop\\Work\\git\\icfpc2020\\haxe\\interp\\src\\interp\\Function.hx"
							return 2;
						}
						
						//line 28 "C:\\Users\\909mm\\Desktop\\Work\\git\\icfpc2020\\haxe\\interp\\src\\interp\\Function.hx"
						break;
					}
					
					
					case 104414:
					{
						//line 22 "C:\\Users\\909mm\\Desktop\\Work\\git\\icfpc2020\\haxe\\interp\\src\\interp\\Function.hx"
						if (__temp_svar1.equals("inc")) 
						{
							//line 22 "C:\\Users\\909mm\\Desktop\\Work\\git\\icfpc2020\\haxe\\interp\\src\\interp\\Function.hx"
							return 1;
						}
						
						//line 22 "C:\\Users\\909mm\\Desktop\\Work\\git\\icfpc2020\\haxe\\interp\\src\\interp\\Function.hx"
						break;
					}
					
					
				}
				
			}
			
		}
		
		//line 18 "C:\\Users\\909mm\\Desktop\\Work\\git\\icfpc2020\\haxe\\interp\\src\\interp\\Function.hx"
		return 0;
	}
	
	
	public static interp.Command execute(java.lang.String this1, haxe.root.Array<interp.Command> args)
	{
		//line 35 "C:\\Users\\909mm\\Desktop\\Work\\git\\icfpc2020\\haxe\\interp\\src\\interp\\Function.hx"
		try 
		{
			//line 37 "C:\\Users\\909mm\\Desktop\\Work\\git\\icfpc2020\\haxe\\interp\\src\\interp\\Function.hx"
			java.lang.String func = haxe.lang.Runtime.toString(this1);
			//line 40 "C:\\Users\\909mm\\Desktop\\Work\\git\\icfpc2020\\haxe\\interp\\src\\interp\\Function.hx"
			try 
			{
				//line 40 "C:\\Users\\909mm\\Desktop\\Work\\git\\icfpc2020\\haxe\\interp\\src\\interp\\Function.hx"
				{
					//line 40 "C:\\Users\\909mm\\Desktop\\Work\\git\\icfpc2020\\haxe\\interp\\src\\interp\\Function.hx"
					java.lang.String __temp_svar1 = (func);
					//line 40 "C:\\Users\\909mm\\Desktop\\Work\\git\\icfpc2020\\haxe\\interp\\src\\interp\\Function.hx"
					if (( __temp_svar1 != null )) 
					{
						//line 40 "C:\\Users\\909mm\\Desktop\\Work\\git\\icfpc2020\\haxe\\interp\\src\\interp\\Function.hx"
						switch (__temp_svar1.hashCode())
						{
							case 96417:
							{
								//line 45 "C:\\Users\\909mm\\Desktop\\Work\\git\\icfpc2020\\haxe\\interp\\src\\interp\\Function.hx"
								if (__temp_svar1.equals("add")) 
								{
									//line 45 "C:\\Users\\909mm\\Desktop\\Work\\git\\icfpc2020\\haxe\\interp\\src\\interp\\Function.hx"
									return interp.Command.Int(( interp.CommandTools.toInt(args.__get(0)) + interp.CommandTools.toInt(args.__get(1)) ));
								}
								
								//line 45 "C:\\Users\\909mm\\Desktop\\Work\\git\\icfpc2020\\haxe\\interp\\src\\interp\\Function.hx"
								break;
							}
							
							
							case 115:
							{
								//line 50 "C:\\Users\\909mm\\Desktop\\Work\\git\\icfpc2020\\haxe\\interp\\src\\interp\\Function.hx"
								if (__temp_svar1.equals("s")) 
								{
									//line 50 "C:\\Users\\909mm\\Desktop\\Work\\git\\icfpc2020\\haxe\\interp\\src\\interp\\Function.hx"
									return interp.CommandTools.ap(interp.CommandTools.ap(args.__get(0), args.__get(2)), interp.CommandTools.ap(args.__get(1), args.__get(2)));
								}
								
								//line 50 "C:\\Users\\909mm\\Desktop\\Work\\git\\icfpc2020\\haxe\\interp\\src\\interp\\Function.hx"
								break;
							}
							
							
							case 98:
							{
								//line 54 "C:\\Users\\909mm\\Desktop\\Work\\git\\icfpc2020\\haxe\\interp\\src\\interp\\Function.hx"
								if (__temp_svar1.equals("b")) 
								{
									//line 54 "C:\\Users\\909mm\\Desktop\\Work\\git\\icfpc2020\\haxe\\interp\\src\\interp\\Function.hx"
									return interp.CommandTools.ap(args.__get(0), interp.CommandTools.ap(args.__get(1), args.__get(2)));
								}
								
								//line 54 "C:\\Users\\909mm\\Desktop\\Work\\git\\icfpc2020\\haxe\\interp\\src\\interp\\Function.hx"
								break;
							}
							
							
							case 108944:
							{
								//line 44 "C:\\Users\\909mm\\Desktop\\Work\\git\\icfpc2020\\haxe\\interp\\src\\interp\\Function.hx"
								if (__temp_svar1.equals("neg")) 
								{
									//line 44 "C:\\Users\\909mm\\Desktop\\Work\\git\\icfpc2020\\haxe\\interp\\src\\interp\\Function.hx"
									return interp.Command.Int( - (interp.CommandTools.toInt(args.__get(0))) );
								}
								
								//line 44 "C:\\Users\\909mm\\Desktop\\Work\\git\\icfpc2020\\haxe\\interp\\src\\interp\\Function.hx"
								break;
							}
							
							
							case 99:
							{
								//line 52 "C:\\Users\\909mm\\Desktop\\Work\\git\\icfpc2020\\haxe\\interp\\src\\interp\\Function.hx"
								if (__temp_svar1.equals("c")) 
								{
									//line 52 "C:\\Users\\909mm\\Desktop\\Work\\git\\icfpc2020\\haxe\\interp\\src\\interp\\Function.hx"
									return interp.CommandTools.ap(interp.CommandTools.ap(args.__get(0), args.__get(2)), args.__get(1));
								}
								
								//line 52 "C:\\Users\\909mm\\Desktop\\Work\\git\\icfpc2020\\haxe\\interp\\src\\interp\\Function.hx"
								break;
							}
							
							
							case 108484:
							{
								//line 46 "C:\\Users\\909mm\\Desktop\\Work\\git\\icfpc2020\\haxe\\interp\\src\\interp\\Function.hx"
								if (__temp_svar1.equals("mul")) 
								{
									//line 46 "C:\\Users\\909mm\\Desktop\\Work\\git\\icfpc2020\\haxe\\interp\\src\\interp\\Function.hx"
									return interp.Command.Int(( interp.CommandTools.toInt(args.__get(0)) * interp.CommandTools.toInt(args.__get(1)) ));
								}
								
								//line 46 "C:\\Users\\909mm\\Desktop\\Work\\git\\icfpc2020\\haxe\\interp\\src\\interp\\Function.hx"
								break;
							}
							
							
							case 99330:
							{
								//line 43 "C:\\Users\\909mm\\Desktop\\Work\\git\\icfpc2020\\haxe\\interp\\src\\interp\\Function.hx"
								if (__temp_svar1.equals("dec")) 
								{
									//line 43 "C:\\Users\\909mm\\Desktop\\Work\\git\\icfpc2020\\haxe\\interp\\src\\interp\\Function.hx"
									return interp.Command.Int(( interp.CommandTools.toInt(args.__get(0)) - 1 ));
								}
								
								//line 43 "C:\\Users\\909mm\\Desktop\\Work\\git\\icfpc2020\\haxe\\interp\\src\\interp\\Function.hx"
								break;
							}
							
							
							case 3464:
							{
								//line 48 "C:\\Users\\909mm\\Desktop\\Work\\git\\icfpc2020\\haxe\\interp\\src\\interp\\Function.hx"
								if (__temp_svar1.equals("lt")) 
								{
									//line 48 "C:\\Users\\909mm\\Desktop\\Work\\git\\icfpc2020\\haxe\\interp\\src\\interp\\Function.hx"
									return interp.Command.Bool(( interp.CommandTools.toInt(args.__get(0)) < interp.CommandTools.toInt(args.__get(1)) ));
								}
								
								//line 48 "C:\\Users\\909mm\\Desktop\\Work\\git\\icfpc2020\\haxe\\interp\\src\\interp\\Function.hx"
								break;
							}
							
							
							case 3244:
							{
								//line 47 "C:\\Users\\909mm\\Desktop\\Work\\git\\icfpc2020\\haxe\\interp\\src\\interp\\Function.hx"
								if (__temp_svar1.equals("eq")) 
								{
									//line 47 "C:\\Users\\909mm\\Desktop\\Work\\git\\icfpc2020\\haxe\\interp\\src\\interp\\Function.hx"
									return interp.Command.Bool(haxe.lang.Runtime.valEq(interp.CommandTools.toString(args.__get(0)), interp.CommandTools.toString(args.__get(1))));
								}
								
								//line 47 "C:\\Users\\909mm\\Desktop\\Work\\git\\icfpc2020\\haxe\\interp\\src\\interp\\Function.hx"
								break;
							}
							
							
							case 104414:
							{
								//line 42 "C:\\Users\\909mm\\Desktop\\Work\\git\\icfpc2020\\haxe\\interp\\src\\interp\\Function.hx"
								if (__temp_svar1.equals("inc")) 
								{
									//line 42 "C:\\Users\\909mm\\Desktop\\Work\\git\\icfpc2020\\haxe\\interp\\src\\interp\\Function.hx"
									return interp.Command.Int(( interp.CommandTools.toInt(args.__get(0)) + 1 ));
								}
								
								//line 42 "C:\\Users\\909mm\\Desktop\\Work\\git\\icfpc2020\\haxe\\interp\\src\\interp\\Function.hx"
								break;
							}
							
							
						}
						
					}
					
				}
				
			}
			catch (java.lang.Throwable _g)
			{
				//line 38 "C:\\Users\\909mm\\Desktop\\Work\\git\\icfpc2020\\haxe\\interp\\src\\interp\\Function.hx"
				if (( ((java.lang.Object) (haxe.Exception.caught(_g).unwrap()) ) instanceof interp.TypeError )) 
				{
					//line 59 "C:\\Users\\909mm\\Desktop\\Work\\git\\icfpc2020\\haxe\\interp\\src\\interp\\Function.hx"
					return interp.Command.Func(func, args);
				}
				else
				{
					//line 38 "C:\\Users\\909mm\\Desktop\\Work\\git\\icfpc2020\\haxe\\interp\\src\\interp\\Function.hx"
					throw _g;
				}
				
			}
			
			
			//line 35 "C:\\Users\\909mm\\Desktop\\Work\\git\\icfpc2020\\haxe\\interp\\src\\interp\\Function.hx"
			return null;
		}
		catch (java.lang.Throwable typedException)
		{
			//line 35 "C:\\Users\\909mm\\Desktop\\Work\\git\\icfpc2020\\haxe\\interp\\src\\interp\\Function.hx"
			throw ((java.lang.RuntimeException) (haxe.Exception.thrown(typedException)) );
		}
		
		
	}
	
	
	public static java.lang.String toString(java.lang.String this1)
	{
		//line 65 "C:\\Users\\909mm\\Desktop\\Work\\git\\icfpc2020\\haxe\\interp\\src\\interp\\Function.hx"
		return this1;
	}
	
	
}


