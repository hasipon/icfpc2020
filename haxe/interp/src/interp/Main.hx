package interp;

import interp.Command;
using interp.CommandTools;

class Main 
{
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
			catch (error:Dynamic)
			{
				Sys.stderr().writeString("error: " + error + "\n");
				break;
			}
		}
		
		var first = true;
		while (env.node.output.length > 0)
		{
			if (!first) Sys.stdout().writeString(" ");
			Sys.stdout().writeString(env.node.output.pop().toString());
			first = false;
		}
		Sys.stdout().writeString("\n");
	}
	
}

private class Environment
{
	public static var variables:Map<String, Array<Command>> = [];
	
	public var input:Array<String>;
	public var node:Node;
	
	public function new(input:Array<String>)
	{
		this.input = input;
		node = new Node();
	}
	
	public function exec():Void
	{
		var data = input.pop();
		if (data == "=")
		{
			variables[input.pop()] = node.output.copy();
		}
		else
		{
			node.add(data);
		}
	}
}

private class Node
{
	public var output:Array<Command>;
	public var child:Node;
	public var tail:Array<Array<Command>>;
	
	public function new()
	{
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
			child = new Node();
		}	
		if (Environment.variables.exists(data))
		{
			for (command in Environment.variables[data])
			{
				output.push(command);
			}
		}
		else
		{
			var command = getCommand(data);
			output.push(command);
		}
	}
	
	public function getCommand(data:String):Command
	{
		if (data == "ap")
		{
			var c  = output.pop();
			if (c == null) throw "ap x: too short args";
			var na = output.pop();
			if (na == null) throw "ap x: too short args";
			return CommandTools.ap(c, na);
			
		}
		for (func in AbstractEnumTools.getValues(Function))
		{
			if (data == func.toString())
			{
				return Command.Func(func, []);
			}	
		}
		var int = Std.parseInt(data);
		if (int != null)
		{
			return Command.Int(int);
		}
		return Command.Unknown(data);
	}
}
