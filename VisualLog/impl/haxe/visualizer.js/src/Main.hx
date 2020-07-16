package;
import js.Browser;
import visualizer.Visualizer;

class Main
{
	private static var currentId:Int;
	private static var visualizers:Array<Visualizer>;
	private static var time:Float;

	public static function main():Void
	{
		currentId = 0;
		visualizers = [];

		Browser.window.addEventListener(
			"load",
			onEnterFrame
		);

		time = Date.now().getTime();
		Browser.window.setInterval(
			onEnterFrame,
			1000 / 60
		);
	}

	public static function onLoad():Void
	{
		readVisualizer();
	}

	public static function onEnterFrame():Void
	{
		readVisualizer();
		
		var nextTime = Date.now().getTime();
		for (visualizer in visualizers)
		{
			visualizer.update(nextTime - time);
		}
		time = nextTime;
	}
	public static function readVisualizer():Void
	{
		var elements = Browser.document.getElementsByClassName("visual-log");
		for (element in elements)
		{
			var elementId = element.getAttribute("visual-id");
			if (elementId == null)
			{
				elementId = "" + (currentId += 1);
				element.setAttribute("visual-id", elementId);

				visualizers.push(new Visualizer(element));
			}
		}
	}
}
