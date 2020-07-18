package interp;

import haxe.Int64;
import interp.VirtualMachine;
import macr.AbstractEnumTools;
import sys.ssl.Key;

class Main 
{
	public static var variables:Map<String, Array<Token>> = [];
	static function main() 
	{
		for (i in 0...0x7FFFFFFF)
		{
			waitInpt();
		}
	}
	
	static function waitInpt():Void
	{
		var line = Sys.stdin().readLine();
		var lexer = new Lexer(line.split(" "));
		
		while (lexer.input.length > 0)
		{
			try
			{
				lexer.exec();
			}
			//catch (error:Dynamic)
			//{
			//	Sys.stdout().writeString("error: " + error + "\n");
			//	return;
			//}
		}
		
		var first = true;
		if (lexer.key != null) 
		{
			Sys.stdout().writeString(lexer.key + " = ");
			
			while (lexer.output.length > 0)
			{
				if (!first) Sys.stdout().writeString(" ");
				var command = lexer.output.pop();
				Sys.stdout().writeString(command.toString());
				first = false;
			}
		}
		else
		{
			var vm = new VirtualMachine(lexer.output);
			vm.start();
			
			while (vm.stack.length > 0)
			{
				if (!first) Sys.stdout().writeString(" ");
				var command = vm.stack.pop();
				Sys.stdout().writeString(command.toString());
				first = false;
			}
		}
		
		Sys.stdout().writeString("\n");
	}
}

private class Lexer
{
	public var key:String;
	private static var intEReg:EReg = ~/^[-0-9]+$/;
	public var output:Array<Token>;
	public var input:Array<String>;
	
	public function new(input:Array<String>)
	{
		this.input = input;
		this.output = [];
	}
	
	public function exec():Void
	{
		var data = input.pop();
		
		if (data == "=")
		{
			var key = input.pop();
			Main.variables[key] = output.copy();
			this.key = key;
		}
		else if (data == "," || data == "(")
		{
			addCommand("cons");
			addCommand("ap");
			addCommand("ap");
		}
		else if (data == ")")
		{
			addCommand("nil");
		}
		else if (data != "")
		{
			addCommand(data);
		}
	}
	
	public function addCommand(data:String):Void
	{
		if (data == "ap")
		{
			output.push(Token.Ap);
			return;
		}
		for (func in macr.AbstractEnumTools.getValues(Function))
		{
			if (data == func.toString())
			{
				output.push(Token.Func(func));
				return;
			}	
		}
		if (data == "vec")
		{
			output.push(Token.Func(Function.cons));
			return;
		}
		if (intEReg.match(data))
		{
			output.push(Token.Int(new BigInteger(data)));
			return;
		}
		output.push(Token.Unknown(data));
		return;
	}
}
