package util;
import haxe.DynamicAccess;
import js.Browser;
import js.html.Element;

class ElementUtil 
{
	public static function element(
		name:String,
		attributes:DynamicAccess<String>,
		?children:Array<Element>
	):Element
	{
		var element = Browser.document.createElement(name);
		for (key in attributes.keys()){
			var value = attributes[key];
			element.setAttribute(key, value);
		}
		if (children != null) for (child in children) element.appendChild(child);
		return element;
	}
	
	public static function div(
		attributes:DynamicAccess<String>,
		?children:Array<Element>
	):Element
	{
		return element("div", attributes, children);
	}
	public static function span(
		attributes:DynamicAccess<String>,
		text:String
	):Element
	{
		var element = Browser.document.createElement("span");
		for (key in attributes.keys()){
			var value = attributes[key];
			element.setAttribute(key, value);
		}
		element.innerHTML = StringTools.htmlEscape(text);
		return element;
	}
	
	public static function enable(element:Element, enabled:Bool):Void
	{
		if (element.hasAttribute("disabled") == enabled)
		{
			if (enabled)
			{
				element.removeAttribute("disabled");
			}
			else
			{
				element.setAttribute("disabled", "disabled");
			}
		}
	}
	
	public static function setText(element:Element, text:String):Void
	{
		element.innerHTML = StringTools.htmlEscape(text);
	}
}
