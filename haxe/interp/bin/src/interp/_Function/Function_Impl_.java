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
		interp._Function.Function_Impl_.add = haxe.lang.Runtime.toString("add");
		//line 10 "C:\\Users\\909mm\\Desktop\\Work\\git\\icfpc2020\\haxe\\interp\\src\\interp\\Function.hx"
		interp._Function.Function_Impl_.mul = haxe.lang.Runtime.toString("mul");
	}
	
	public static java.lang.String inc;
	
	public static java.lang.String dec;
	
	public static java.lang.String add;
	
	public static java.lang.String mul;
	
	public static int getRequiredSize(java.lang.String this1)
	{
		//line 14 "C:\\Users\\909mm\\Desktop\\Work\\git\\icfpc2020\\haxe\\interp\\src\\interp\\Function.hx"
		{
			//line 14 "C:\\Users\\909mm\\Desktop\\Work\\git\\icfpc2020\\haxe\\interp\\src\\interp\\Function.hx"
			java.lang.String __temp_svar1 = (haxe.lang.Runtime.toString(this1));
			//line 14 "C:\\Users\\909mm\\Desktop\\Work\\git\\icfpc2020\\haxe\\interp\\src\\interp\\Function.hx"
			if (( __temp_svar1 != null )) 
			{
				//line 14 "C:\\Users\\909mm\\Desktop\\Work\\git\\icfpc2020\\haxe\\interp\\src\\interp\\Function.hx"
				switch (__temp_svar1.hashCode())
				{
					case 96417:
					{
						//line 18 "C:\\Users\\909mm\\Desktop\\Work\\git\\icfpc2020\\haxe\\interp\\src\\interp\\Function.hx"
						if (__temp_svar1.equals("add")) 
						{
							//line 18 "C:\\Users\\909mm\\Desktop\\Work\\git\\icfpc2020\\haxe\\interp\\src\\interp\\Function.hx"
							return 2;
						}
						
						//line 18 "C:\\Users\\909mm\\Desktop\\Work\\git\\icfpc2020\\haxe\\interp\\src\\interp\\Function.hx"
						break;
					}
					
					
					case 108484:
					{
						//line 19 "C:\\Users\\909mm\\Desktop\\Work\\git\\icfpc2020\\haxe\\interp\\src\\interp\\Function.hx"
						if (__temp_svar1.equals("mul")) 
						{
							//line 19 "C:\\Users\\909mm\\Desktop\\Work\\git\\icfpc2020\\haxe\\interp\\src\\interp\\Function.hx"
							return 2;
						}
						
						//line 19 "C:\\Users\\909mm\\Desktop\\Work\\git\\icfpc2020\\haxe\\interp\\src\\interp\\Function.hx"
						break;
					}
					
					
					case 99330:
					{
						//line 17 "C:\\Users\\909mm\\Desktop\\Work\\git\\icfpc2020\\haxe\\interp\\src\\interp\\Function.hx"
						if (__temp_svar1.equals("dec")) 
						{
							//line 17 "C:\\Users\\909mm\\Desktop\\Work\\git\\icfpc2020\\haxe\\interp\\src\\interp\\Function.hx"
							return 1;
						}
						
						//line 17 "C:\\Users\\909mm\\Desktop\\Work\\git\\icfpc2020\\haxe\\interp\\src\\interp\\Function.hx"
						break;
					}
					
					
					case 104414:
					{
						//line 16 "C:\\Users\\909mm\\Desktop\\Work\\git\\icfpc2020\\haxe\\interp\\src\\interp\\Function.hx"
						if (__temp_svar1.equals("inc")) 
						{
							//line 16 "C:\\Users\\909mm\\Desktop\\Work\\git\\icfpc2020\\haxe\\interp\\src\\interp\\Function.hx"
							return 1;
						}
						
						//line 16 "C:\\Users\\909mm\\Desktop\\Work\\git\\icfpc2020\\haxe\\interp\\src\\interp\\Function.hx"
						break;
					}
					
					
				}
				
			}
			
		}
		
		//line 12 "C:\\Users\\909mm\\Desktop\\Work\\git\\icfpc2020\\haxe\\interp\\src\\interp\\Function.hx"
		return 0;
	}
	
	
	public static interp.Command execute(java.lang.String this1, haxe.root.Array<interp.Command> args)
	{
		//line 25 "C:\\Users\\909mm\\Desktop\\Work\\git\\icfpc2020\\haxe\\interp\\src\\interp\\Function.hx"
		{
			//line 25 "C:\\Users\\909mm\\Desktop\\Work\\git\\icfpc2020\\haxe\\interp\\src\\interp\\Function.hx"
			java.lang.String __temp_svar1 = (haxe.lang.Runtime.toString(this1));
			//line 25 "C:\\Users\\909mm\\Desktop\\Work\\git\\icfpc2020\\haxe\\interp\\src\\interp\\Function.hx"
			if (( __temp_svar1 != null )) 
			{
				//line 25 "C:\\Users\\909mm\\Desktop\\Work\\git\\icfpc2020\\haxe\\interp\\src\\interp\\Function.hx"
				switch (__temp_svar1.hashCode())
				{
					case 96417:
					{
						//line 29 "C:\\Users\\909mm\\Desktop\\Work\\git\\icfpc2020\\haxe\\interp\\src\\interp\\Function.hx"
						if (__temp_svar1.equals("add")) 
						{
							//line 29 "C:\\Users\\909mm\\Desktop\\Work\\git\\icfpc2020\\haxe\\interp\\src\\interp\\Function.hx"
							return interp.Command.Int(( interp.CommandTools.toInt(args.__get(0)) + interp.CommandTools.toInt(args.__get(1)) ));
						}
						
						//line 29 "C:\\Users\\909mm\\Desktop\\Work\\git\\icfpc2020\\haxe\\interp\\src\\interp\\Function.hx"
						break;
					}
					
					
					case 108484:
					{
						//line 30 "C:\\Users\\909mm\\Desktop\\Work\\git\\icfpc2020\\haxe\\interp\\src\\interp\\Function.hx"
						if (__temp_svar1.equals("mul")) 
						{
							//line 30 "C:\\Users\\909mm\\Desktop\\Work\\git\\icfpc2020\\haxe\\interp\\src\\interp\\Function.hx"
							return interp.Command.Int(( interp.CommandTools.toInt(args.__get(0)) * interp.CommandTools.toInt(args.__get(1)) ));
						}
						
						//line 30 "C:\\Users\\909mm\\Desktop\\Work\\git\\icfpc2020\\haxe\\interp\\src\\interp\\Function.hx"
						break;
					}
					
					
					case 99330:
					{
						//line 28 "C:\\Users\\909mm\\Desktop\\Work\\git\\icfpc2020\\haxe\\interp\\src\\interp\\Function.hx"
						if (__temp_svar1.equals("dec")) 
						{
							//line 28 "C:\\Users\\909mm\\Desktop\\Work\\git\\icfpc2020\\haxe\\interp\\src\\interp\\Function.hx"
							return interp.Command.Int(( interp.CommandTools.toInt(args.__get(0)) - 1 ));
						}
						
						//line 28 "C:\\Users\\909mm\\Desktop\\Work\\git\\icfpc2020\\haxe\\interp\\src\\interp\\Function.hx"
						break;
					}
					
					
					case 104414:
					{
						//line 27 "C:\\Users\\909mm\\Desktop\\Work\\git\\icfpc2020\\haxe\\interp\\src\\interp\\Function.hx"
						if (__temp_svar1.equals("inc")) 
						{
							//line 27 "C:\\Users\\909mm\\Desktop\\Work\\git\\icfpc2020\\haxe\\interp\\src\\interp\\Function.hx"
							return interp.Command.Int(( interp.CommandTools.toInt(args.__get(0)) + 1 ));
						}
						
						//line 27 "C:\\Users\\909mm\\Desktop\\Work\\git\\icfpc2020\\haxe\\interp\\src\\interp\\Function.hx"
						break;
					}
					
					
				}
				
			}
			
		}
		
		//line 23 "C:\\Users\\909mm\\Desktop\\Work\\git\\icfpc2020\\haxe\\interp\\src\\interp\\Function.hx"
		return null;
	}
	
	
	public static java.lang.String toString(java.lang.String this1)
	{
		//line 36 "C:\\Users\\909mm\\Desktop\\Work\\git\\icfpc2020\\haxe\\interp\\src\\interp\\Function.hx"
		return this1;
	}
	
	
}


