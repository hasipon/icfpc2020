package framework.command.write;

class NullCommandWriter<RootData> implements CommandWriter<RootData>
{
	public function new()
	{
	}

	public function write<Data>(
		kind:String,
		index:Int,
		data:Data, 
		wrap:Data->RootData,
		handler:String->Int->Data->Void
	):Void
	{
	}
}
