package visualizer.ctrl;
import js.Browser;
import js.html.Element;
import js.html.Event;
import js.html.InputElement;
import visualizer.state.VisualizerDisplayState;
import util.ElementUtil.*;
import visualizer.state.VisualizerState;
using util.ElementUtil;

class VisualControlView 
{
	private var frameSize:Float;
	private var step:Float;
	
	private var playing:Bool;
	private var backwardButton:Element;
	private var startButton:Element;
	private var forwardButton:Element;
	private var frameText:Element;
	private var fastBackstepButton:Element;
	private var fastStepButton:Element;
	private var backstepButton:Element;
	private var stepButton:Element;
	
	private var frameRange:InputElement;
	private var visualizer:Visualizer;
	private var controling:Bool;
	private var previousPlaying:Bool;
	private var previousFps:Float;
	
	public function new(
		visualizer:Visualizer, 
		container:Element
	) 
	{
		this.visualizer = visualizer;
		this.step = -1;
		this.frameSize = 0;
		this.playing = false;
		this.previousPlaying = false;
		this.controling = false;
		
		container.appendChild(
			div(
				{ "class" : "row" },
				[
					backwardButton = "button".element(
						{ 
							"class": "small",
							disabled: "disabled"
						},
						[
							span({"class":"icon-sb_playback_rewind"}, "")
						]
					),
					startButton = "button".element(
						{ 
							"class": "big",
							disabled: "disabled"
						},
						[
							span({"class":"icon-sb_playback_play"}, "")
						]
					),
					forwardButton = "button".element(
						{ 
							"class": "small",
							disabled: "disabled"
						},
						[
							span({"class":"icon-sb_playback_fastforward"}, "")
						]
					),
					frameRange = cast "input".element(
						{ 
							"class" : "frame-range", 
							type    : "range",
							value   : "0",
							min     : "0",
							max     : "0",
							step    : "1",
							disabled: "disabled"
						},
						[]
					),
					fastBackstepButton = "button".element(
						{ 
							"class": "small",
							disabled: "disabled"
						},
						[
							span({"class":"icon-sb_arrow_d_left"}, "")
						]
					),
					backstepButton = "button".element(
						{ 
							"class": "small",
							disabled: "disabled"
						},
						[
							span({"class":"icon-sb_arrow_s_left"}, "")
						]
					),
					frameText = span({"class":"frame-text"}, ""),
					stepButton = "button".element(
						{ 
							"class": "small",
							disabled: "disabled"
						},
						[
							span({"class":"icon-sb_arrow_s_right"}, "")
						]
					),
					fastStepButton = "button".element(
						{ 
							"class": "small",
							disabled: "disabled"
						},
						[
							span({"class":"icon-sb_arrow_d_right"}, "")
						]
					),
				]
			)
		);
		
		backwardButton.addEventListener("mousedown", onBackwardDown);
		forwardButton.addEventListener("mousedown", onForwardDown);
		Browser.window.addEventListener("mouseup", onWindowUp);
		frameRange.addEventListener("input", onFrameRangeInput);
		frameRange.addEventListener("change", onFrameRangeChange);
		startButton.addEventListener("click", onStartClick);
		
		fastBackstepButton.addEventListener("click", onFastBackstepClick);
		backstepButton.addEventListener("click", onBackstepClick);
		fastStepButton.addEventListener("click", onFastStepClick);
		stepButton.addEventListener("click", onStepClick);
	}
	
	private function onForwardDown(e:Event):Void 
	{
		var input:InputElement = cast e.target;
		switch (visualizer.state)
		{
			case VisualizerState.None | VisualizerState.Loading(_):
			case VisualizerState.Display(state):
				if (!controling)
				{
					controling = true;
					previousPlaying = state.playing;
					previousFps = state.fps;
					state.playing = true;
					state.fps *= 10;
				}
		}
	}
	private function onBackwardDown(e:Event):Void 
	{
		var input:InputElement = cast e.target;
		switch (visualizer.state)
		{
			case VisualizerState.None | VisualizerState.Loading(_):
			case VisualizerState.Display(state):
				if (!controling)
				{
					controling = true;
					previousPlaying = state.playing;
					previousFps = state.fps;
					state.playing = true;
					state.fps *= -10;
				}
		}
	}
	private function onWindowUp(e:Event):Void 
	{
		var input:InputElement = cast e.target;
		switch (visualizer.state)
		{
			case VisualizerState.None | VisualizerState.Loading(_):
			case VisualizerState.Display(state):
				if (controling)
				{
					controling = false;
					state.playing = previousPlaying;
					state.fps = previousFps;
				}
		}
	}
	private function onFrameRangeInput(e:Event):Void 
	{
		var input:InputElement = cast e.target;
		switch (visualizer.state)
		{
			case VisualizerState.None | VisualizerState.Loading(_):
			case VisualizerState.Display(state):
				if (!controling)
				{
					controling = true;
					previousPlaying = state.playing;
					previousFps = state.fps;
					state.playing = false;
				}
				state.goto(Std.parseFloat(input.value));
		}
	}
	private function onFrameRangeChange(e:Event):Void 
	{
		var input:InputElement = cast e.target;
		switch (visualizer.state)
		{
			case VisualizerState.None | VisualizerState.Loading(_):
			case VisualizerState.Display(state):
				if (controling)
				{
					controling = false;
					state.playing = previousPlaying;
				}
				state.goto(Std.parseFloat(input.value));
		}
	}
	private function onStartClick(e:Event):Void 
	{
		switch (visualizer.state)
		{
			case VisualizerState.None | VisualizerState.Loading(_):
			case VisualizerState.Display(state):
				state.playing = !state.playing;
		}
	}
	private function onFastBackstepClick(e:Event):Void 
	{
		switch (visualizer.state)
		{
			case VisualizerState.None | VisualizerState.Loading(_):
			case VisualizerState.Display(state):
				state.proceed(-5);
		}
	}
	private function onBackstepClick(e:Event):Void 
	{
		switch (visualizer.state)
		{
			case VisualizerState.None | VisualizerState.Loading(_):
			case VisualizerState.Display(state):
				state.proceed(-1);
		}
	}
	private function onStepClick(e:Event):Void 
	{
		switch (visualizer.state)
		{
			case VisualizerState.None | VisualizerState.Loading(_):
			case VisualizerState.Display(state):
				state.proceed(1);
		}
	}
	private function onFastStepClick(e:Event):Void 
	{
		switch (visualizer.state)
		{
			case VisualizerState.None | VisualizerState.Loading(_):
			case VisualizerState.Display(state):
				state.proceed(5);
		}
	}
	
	public function stop():Void
	{
		forwardButton.enable(false);
		startButton.enable(false);
		backwardButton.enable(false);
		backstepButton.enable(false);
		frameRange.enable(false);
		stepButton.enable(false);
		fastBackstepButton.enable(false);
		fastStepButton.enable(false);
	}
	
	public function update(state:VisualizerDisplayState):Void 
	{
		forwardButton.enable(true);
		startButton.enable(true);
		backwardButton.enable(true);
		backstepButton.enable(true);
		frameRange.enable(true);
		stepButton.enable(true);
		fastBackstepButton.enable(true);
		fastStepButton.enable(true);
		
		if (playing != state.playing)
		{
			playing = state.playing;
			startButton.removeChild(startButton.firstChild);
			startButton.appendChild(
				span(
					{"class":if (state.playing) "icon-sb_playback_suspend" else "icon-sb_playback_play"}, 
					""
				)
			);
		}
		if (step != state.step || frameSize != state.frameSize)
		{
			frameSize = state.frameSize;
			frameRange.setAttribute("max", (frameSize - 1) + "");
			frameText.setText(
				(state.step + 1)
				+ "/" + 
				(state.frameSize)
			);
		}
		if (step != state.step)
		{
			step = state.step;
			frameRange.value = step + "";
		}
	}
}