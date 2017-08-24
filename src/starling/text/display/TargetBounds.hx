package starling.text.display;

import starling.display.Quad;
import starling.display.Sprite;
import starling.events.Event;

/**
 * ...
 * @author P.J.Shand
 */
class TargetBounds extends Sprite
{
	private static inline var borderThickness:Int = 3;
	private var _height:Null<Float>;
	private var background:Quad;
	var textDisplay:TextDisplay;
	//var border:Canvas;
	
	var border:Sprite;
	var borderTop:Quad;
	var borderBottom:Quad;
	var borderLeft:Quad;
	var borderRight:Quad;
	
	@:isVar public var showBorder(default, set):Bool = false;
	
	public function new(textDisplay:TextDisplay, width:Float, _height:Null<Float>) 
	{
		super();
		this.textDisplay = textDisplay;
		_height = (_height != null) ? _height : 50;
		background = new Quad(width, _height, 0x0000FF);
		addChild(background);
		
		border = new Sprite();
		addChild(border);
		
		borderTop = new Quad(1, 1, 0xFFFFFFFF);
		border.addChild(borderTop);
		
		borderBottom = new Quad(1, 1, 0xFFFFFFFF);
		border.addChild(borderBottom);
		
		borderLeft = new Quad(1, 1, 0xFFFFFFFF);
		border.addChild(borderLeft);
		
		borderRight = new Quad(1, 1, 0xFFFFFFFF);
		border.addChild(borderRight);
		
		
		updateBorder(width, _height);
		border.visible = false;
		
		background.alpha = 0;
		
		textDisplay.charLayout.addEventListener(Event.RESIZE, OnLayoutChange);
	}
	
	private function OnLayoutChange(e:Event):Void 
	{
		if (textDisplay.autoSize == TextFieldAutoSize.NONE) {
			background.width = textDisplay.targetWidth;
			background.height = textDisplay.targetHeight;
		}
		else if (textDisplay.autoSize == TextFieldAutoSize.BOTH_DIRECTIONS) {
			background.width = textDisplay.textWidth;
			background.height = textDisplay.textHeight;
		}
		else if (textDisplay.autoSize == TextFieldAutoSize.HORIZONTAL) {
			background.width = textDisplay.textWidth;
			background.height = textDisplay.targetHeight;
		}
		else if (textDisplay.autoSize == TextFieldAutoSize.VERTICAL) {
			background.width = textDisplay.targetWidth;
			background.height = textDisplay.textHeight;
		}
		updateBorder(background.width, background.height);
	}
	
	private function updateBorder(width:Float, height:Float) 
	{
		borderTop.color = borderBottom.color = borderLeft.color = borderRight.color = 0xFFFFFF;
		
		borderTop.x = 0;
		borderTop.y = 0;
		borderTop.width = width;
		borderTop.height = borderThickness;
		
		borderBottom.x = 0;
		borderBottom.y = height - borderThickness;
		borderBottom.width = width;
		borderBottom.height = borderThickness;
		
		borderLeft.x = 0;
		borderLeft.y = borderThickness;
		borderLeft.width = borderThickness;
		borderLeft.height = height - borderThickness;
		
		borderRight.x = width - borderThickness;
		borderRight.y = borderThickness;
		borderRight.width = borderThickness;
		borderRight.height = height - borderThickness;
	}
	
	private function set_showBorder(value:Bool):Bool
	{
		return border.visible = value;
	}
}