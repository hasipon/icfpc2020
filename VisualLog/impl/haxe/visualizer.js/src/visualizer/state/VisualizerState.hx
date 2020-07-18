package visualizer.state;

enum VisualizerState
{
	None;
	Loading(state:VisualizerLoadingState);
	Display(state:VisualizerDisplayState);
}
