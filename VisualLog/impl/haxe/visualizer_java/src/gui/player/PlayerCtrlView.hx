package gui.player;
import framework.tree.INodeHolder;
import framework.tree.NodeHolder;
import haxe.Resource;
import java.javax.swing.JButton;
import java.javax.swing.JPanel;
import java.javax.swing.JSlider;
import java.javax.swing.JLabel;
import java.javax.swing.ImageIcon;
import java.awt.BorderLayout;
import java.awt.FlowLayout;
import java.awt.Dimension;

class PlayerCtrlView extends NodeHolder
{
	public var panel:JPanel;
	
	private var rewindButton:JButton;
	private var playButton:JButton;
	private var forwardButton:JButton;
	
	private var slider:JSlider;
	
	private var largePrevButton:JButton;
	private var prevButton:JButton;
	private var stepLabel:JLabel;
	private var nextButton:JButton;
	private var largeNextButton:JButton;
	
	private var playingIcon:ImageIcon;
	private var stopIcon:ImageIcon;
	
	private var logic:PlayerLogic;
	
	public function new(
		parent:INodeHolder,
		logic:PlayerLogic
	) 
	{
		super(parent);
		this.logic = logic;
		panel = new JPanel();
		panel.setLayout(new BorderLayout());
		
		var leftPanel = new JPanel();
		leftPanel.setLayout(new FlowLayout(FlowLayout.LEFT, 2, 2));
		rewindButton = new JButton("", getIcon("playback_rewind"));
		rewindButton.setPreferredSize(new Dimension(32, 42));
		leftPanel.add(rewindButton);
		
		playingIcon = getIcon("playback_play");
		stopIcon = getIcon("playback_suspend");
		
		playButton = new JButton("", playingIcon);
		playButton.setPreferredSize(new Dimension(53, 42));
		leftPanel.add(playButton);
		
		forwardButton = new JButton("", getIcon("playback_fastforward"));
		forwardButton.setPreferredSize(new Dimension(32, 42));
		leftPanel.add(forwardButton);
		panel.add(leftPanel, BorderLayout.LINE_START);
		
		slider = new JSlider();
		panel.add(slider, BorderLayout.CENTER);
		
		var rightPanel = new JPanel();
		rightPanel.setLayout(new FlowLayout(FlowLayout.LEFT, 2, 2));
		largePrevButton = new JButton("", getIcon("arrow_d_left"));
		largePrevButton.setPreferredSize(new Dimension(32, 42));
		rightPanel.add(largePrevButton);
		
		prevButton = new JButton("", getIcon("arrow_s_left"));
		prevButton.setPreferredSize(new Dimension(32, 42));
		rightPanel.add(prevButton);
		
		stepLabel = new JLabel(" " + logic.currentStep + "/" + logic.maxStep+ " ");
		stepLabel.setPreferredSize(new Dimension(32, 42));
		rightPanel.add(stepLabel);
		
		nextButton = new JButton("", getIcon("arrow_s_right"));
		nextButton.setPreferredSize(new Dimension(32, 42));
		rightPanel.add(nextButton);
		
		largeNextButton = new JButton("", getIcon("arrow_d_right"));
		largeNextButton.setPreferredSize(new Dimension(32, 42));
		rightPanel.add(largeNextButton);
		panel.add(rightPanel, BorderLayout.LINE_END);
	}
	
	private static function getIcon(key:String):ImageIcon
	{
		var bytes = Resource.getBytes('resources/icon/pb016_$key.png');
		return new ImageIcon(bytes.getData());
	}
	
	public function update():Void
	{
		if (!node.synchronizeVersion(logic.node))
		{
			return;
		}
		
		playButton.setIcon(if (logic.playing) stopIcon else playingIcon);
		
		rewindButton.setEnabled(logic.loaded);
		playButton.setEnabled(logic.loaded);
		forwardButton.setEnabled(logic.loaded);
		
		slider.setEnabled(logic.loaded);
		
		largePrevButton.setEnabled(logic.loaded);
		prevButton.setEnabled(logic.loaded);
		stepLabel.setEnabled(logic.loaded);
		nextButton.setEnabled(logic.loaded);
		largeNextButton.setEnabled(logic.loaded);
		
		slider.setMaximum(logic.currentStep);
		slider.setMaximum(logic.maxStep);
	}
}
