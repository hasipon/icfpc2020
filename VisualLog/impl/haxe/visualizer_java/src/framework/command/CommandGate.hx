package framework.command;
import framework.command.write.CommandWriter;
import framework.tree.INodeHolder;
import framework.tree.NodeHolder;
import haxe.EnumTools.EnumValueTools;
import haxe.ds.Map;

class CommandGate<RootData:EnumValue> extends NodeHolder
{
	private var queues:Array<CommandQueue<Dynamic>>;
	private var tempQueues:Array<CommandQueue<Dynamic>>;
	
	private var queueToSetting:Map<CommandQueue<Dynamic>, QueueSetting<RootData>>;
	private var kindToQueue:Map<String, Map<Int, CommandQueue<Dynamic>>>;
	private var currentIndexes:Map<String, Int>;
	private var commandWriter:CommandWriter<RootData>;
	
	public function new(
		parent:INodeHolder,
		commandWriter:CommandWriter<RootData>
	):Void
	{
		super(parent);
		this.commandWriter = commandWriter;
		
		queues = [];
		tempQueues = [];
		
		queueToSetting = new Map();
		kindToQueue = new Map();
		currentIndexes = new Map();
	}
	
	public function update():Void
	{
		if (node.disposed) { return; }
		for (i in 0...queues.length)
		{
			tempQueues.push(queues.pop());
		}
		for (i in 0...tempQueues.length)
		{
			var queue = tempQueues.pop();
			if (queue.node.disposed) { continue; }
			
			var setting = queueToSetting[queue];
			queue.execute(
				function (command:Dynamic):Void
				{
					commandWriter.write(
						setting.kind,
						setting.index,
						command,
						setting.wrap,
						call
					);
				}
			);
			queues.push(queue);
		}
		node.incrementVersion();
	}
	
	public function createQueue<Data>(
		parent:INodeHolder,
		wrap:Data->RootData,
		handler:Data->Void
	):CommandQueue<Data>
	{
		var enumValue = wrap(null);
		var kind = EnumValueTools.getName(enumValue);
		
		var queue = new CommandQueue(parent);
		var indexToQueue, index;
		if (kindToQueue.exists(kind))
		{
			index = (currentIndexes[kind] += 1);
			indexToQueue = kindToQueue[kind];
		}
		else
		{
			index = currentIndexes[kind] = 0;
			indexToQueue = kindToQueue[kind] = new Map();
		}
		indexToQueue[index] = queue;
		queues.push(queue);
		var setting = new QueueSetting<RootData>(
			this,
			queue,
			kind,
			index,
			wrap,
			handler
		);
		queueToSetting[queue] = setting;
		queue.node.addDisposeHandler(setting.dispose);
		
		node.incrementVersion();
		
		return queue;
	}
	
	public function call(kind:String, index:Int, data:Dynamic):Void
	{
		if (kindToQueue.exists(kind))
		{
			var indexToQueue = kindToQueue[kind];
			if (indexToQueue.exists(index))
			{
				var queue = indexToQueue[index];
				var setting = queueToSetting[queue];
				setting.handler(data);
			}
		}
	}
}

@:access(framework.command.CommandGate)
private class QueueSetting<RootData:EnumValue>
{
	public var gate:CommandGate<RootData>;
	public var queue:CommandQueue<Dynamic>;
	public var kind:String;
	public var index:Int;
	public var handler:Dynamic->Void;
	public var wrap:Dynamic->RootData;
	
	public function new(
		gate:CommandGate<RootData>,
		queue:CommandQueue<Dynamic>,
		kind:String,
		index:Int,
		wrap:Dynamic->RootData,
		handler:Dynamic->Void
	)
	{
		this.queue = queue;
		this.gate = gate;
		this.kind = kind;
		this.index = index;
		this.handler = handler;
		this.wrap = wrap;
	}
	
	public function dispose():Void
	{
		gate.queues.remove(queue);
		gate.queueToSetting.remove(queue);
		gate.kindToQueue[kind].remove(index);
	}
}
