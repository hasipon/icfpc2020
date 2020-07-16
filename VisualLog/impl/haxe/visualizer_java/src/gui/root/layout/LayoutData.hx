package gui.root.layout;

@:forward
typedef LayoutData = {
	rootFrame: RootFrameLayoutData,
}

@:forward
typedef RootFrameLayoutData = {
	x: Int,
	y: Int,
	width: Int,
	height: Int,
	extendedState: Int
}
