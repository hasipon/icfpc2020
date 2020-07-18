package framework.command.write;

interface CommandWriter<RootData>
{
	public function write<Data>(
		kind:String,
		index:Int,
		data:Data, 
		wrap:Data->RootData,
		handler:String->Int->Data->Void
	):Void;
}
