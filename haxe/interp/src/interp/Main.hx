package interp;

import haxe.Int64;
import interp.Command;
import interp.Valiables;
import sys.ssl.Key;
using interp.CommandTools;

class Main 
{
	public static var variables:Map<String, Valiables> = [];
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
		var env = new Environment(line.split(" "));
		
		while (env.input.length > 0)
		{
			try
			{
				env.exec();
			}
			//catch (error:Dynamic)
			//{
			//	Sys.stdout().writeString("error: " + error + "\n");
			//	return;
			//}
		}
		
		var first = true;
		if (env.key != null) 
		{
			Sys.stdout().writeString(env.key + " = ");
		}
		while (env.node.output.length > 0)
		{
			if (!first) Sys.stdout().writeString(" | ");
			var command = env.node.output.pop();
			Sys.stdout().writeString(command.toString());
			first = false;
		}
		Sys.stdout().writeString("\n");
	}
}

private class Environment
{
	public var key:String;
	public var input:Array<String>;
	public var node:Node;
	
	public function new(input:Array<String>)
	{
		this.input = input;
		node = new Node(this);
	}
	
	public function exec():Void
	{
		var data = input.pop();
		
		if (data == "=")
		{
			var key = input.pop();
			var value = node.output.copy();
			if (value.length != 1)
			{
				throw "invalid value size: " + 1;
			}
			Main.variables[key] = new Valiables(value[0]);
			this.key = key;
			return;
		}
		
		node.add(data);
	}
}

private class Node
{
	private static var intEReg:EReg = ~/^[-0-9]+$/;
	public var env:Environment;
	public var output:Array<Command>;
	public var child:Node;
	public var tail:Array<Array<Command>>;
	
	public function new(env:Environment)
	{
		this.env = env;
		output = [];
		tail = [];
		child = null;
	}
	
	public function add(data:String):Void
	{
		if (child != null)
		{
			if (data == "(")
			{
				var list = Command.Func(Function.nil, []);
				for (out in child.tail)
				{
					if (out.length > 0)
					{
						list = Command.Func(Function.cons, [out.pop(), list]);
					}
				}
				if (child.output.length > 0)
				{
					list = Command.Func(Function.cons, [child.output.pop(), list]);
				}
				output.push(list);
				child = null;
			}
			else
			{
				child.add(data);
			}
		}
		else if (data == ",")
		{
			tail.push(output);
			output = [];
		}
		else if (data == ")")
		{
			child = new Node(env);
		}
		else
		{
			addCommand(data);
		}
	}
	
	public function addCommand(data:String):Void
	{
		if (data == "ap")
		{
			var c  = output.pop();
			if (c == null) throw "ap x: too short args";
			var na = output.pop();
			if (na == null) throw "ap x: too short args: " + c;
			output.push(CommandTools.ap(c, na));
			return;
		}
		for (func in AbstractEnumTools.getValues(Function))
		{
			if (data == func.toString())
			{
				output.push(Command.Func(func, []));
				return;
			}	
		}
		if (data == "vec")
		{
			output.push(Command.Func(Function.cons, []));
			return;
		}
		
		if (intEReg.match(data))
		{
			output.push(Command.Int(Int64.parseString(data)));
			return;
		}
		output.push(Command.Unknown(data));
		return;
	}
}
