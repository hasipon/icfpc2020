package framework.tree;
import haxe.macro.ComplexTypeTools;
import haxe.macro.Context;
import haxe.macro.Expr.Access;
import haxe.macro.Expr.Field;
import haxe.macro.Expr.FieldType;
import haxe.macro.ExprTools;
import haxe.macro.Type.ClassField;
import haxe.macro.Type.ClassType;
import haxe.macro.Type.ClassType;
import haxe.macro.TypeTools;

class NodeMacro 
{
	public static function autoBuild():Array<Field>
	{
		var fields:Array<Field> = [];
		for (field in Context.getBuildFields())
		{
			if (field.meta != null)
			{
				for (metaEntry in field.meta)
				{
					switch (metaEntry.name)
					{
						case ":forward":
							switch (field.kind)
							{
								case FieldType.FVar(t, e) | FieldType.FProp(_, _, t, e):
									var params = metaEntry.params;
									if (params == null || params.length == 0)
									{
										Context.warning("Parameter required.", metaEntry.pos);
										continue;
									}
									var acccessName = ExprTools.toString(params[0]);
									var fieldName = if (params.length < 2) acccessName else ExprTools.toString(params[1]);
									var returnType = TypeTools.toComplexType(getField(TypeTools.getClass(ComplexTypeTools.toType(t)), fieldName).type);
									
									fields.push({
										name : fieldName,
										doc : null,
										access : [Access.APrivate],
										kind : FieldType.FProp("get", "never", returnType, null),
										pos : metaEntry.pos
									});
									fields.push({
										name : "get_" + fieldName,
										doc : null,
										access : [Access.APrivate],
										kind : FieldType.FFun(
											{
												args : [],
												ret : returnType,
												expr : macro @:pos(metaEntry.pos) {
													return $i{field.name}.$acccessName;
												}
											}
										),
										pos : metaEntry.pos
									});
									
								case FieldType.FFun(_):
									Context.warning("Property can't forward.", metaEntry.pos);
							}
							
						case ":absorb":
							switch (field.kind)
							{
								case FieldType.FVar(t, e):
									if (t == null)
									{
										Context.warning("Type is required.", metaEntry.pos);
										continue;
									}
									field.kind = FieldType.FProp("get", "null", t, e);
									var name = field.name;
									var typeExpr = TypeTools.toString(ComplexTypeTools.toType(t));
									fields.push({
										name : "get_" + name,
										doc : null,
										access : [Access.APrivate],
										kind : FieldType.FFun(
											{
												args : [],
												ret : t,
												expr : macro @:pos(metaEntry.pos) {
													if ($i{name} == null) 
													{
														$i{name} = node.absorbByKey($v{typeExpr});
													}
													return $i{name};
												}
											}
										),									
										pos : metaEntry.pos
									});
									
								case FieldType.FProp(_):
									Context.warning("Property can't absorb.", metaEntry.pos);
									
								case FieldType.FFun(_):
									Context.warning("Function can't absorb.", metaEntry.pos);
							}
							
						case _:
					}
				}
			}
			fields.push(field);
		}
		return fields;
	}
	
	private static function getField(type:ClassType, fieldName:String):ClassField
	{
		for (field in type.fields.get())
		{
			if (field.name == fieldName) 
			{
				return field;
			}
		}
		if (type.isInterface)
		{
			for (type in type.interfaces)
			{
				getField(type.t.get(), fieldName);
			}
		}
		else if (type.superClass != null)
		{
			getField(type.superClass.t.get(), fieldName);
		}
		return null;
	}
}
