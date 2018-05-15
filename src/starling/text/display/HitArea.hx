package starling.text.display;

import openfl.geom.Rectangle;
import starling.display.Canvas;
import starling.display.Quad;
import starling.display.Sprite;
import starling.events.Event;

/**
 * ...
 * @author P.J.Shand
 */
class HitArea extends Sprite
{
	private static inline var borderThinkness:Int = 3;
	private var _height:Null<Float>;
	private var background:Quad;
	var textDisplay:TextDisplay;
	var border:Canvas;
	var textBounds = new Rectangle(0,0,100,100);
	
	@:isVar public var showBorder(default, set):Bool = false;
	
	public function new(textDisplay:TextDisplay, width:Float, _height:Null<Float>) 
	{
		super();
		this.textDisplay = textDisplay;
		_height = (_height != null) ? _height : 50;
		
		background = new Quad(width, _height, 0x00FF00);
		addChild(background);
		background.alpha = 0;
		
		border = new Canvas();
		addChild(border);
		border.visible = false;
		
		textDisplay.charLayout.addEventListener(Event.CHANGE, OnLayoutChange);
		OnLayoutChange(null);
	}
	
	private function OnLayoutChange(e:Event):Void 
	{
		if (textDisplay.stage == null) return;
		
		textBounds.setTo(textDisplay.targetBounds.x, textDisplay.targetBounds.y, textDisplay.targetBounds.width, textDisplay.targetBounds.height);
		
		background.x = textBounds.x;
		background.y = textBounds.y;
		background.width = textBounds.width;
		background.height = textBounds.height;
		if (background.width < 10) background.width = 10;
		if (background.height < 10) background.height = 10;
		updateBorder();
	}
	
	private function updateBorder() 
	{
		var w = textDisplay.targetWidth;
		var h = textDisplay.targetHeight;
		border.clear();
		border.beginFill(0xFF0000);
		border.drawRectangle(textBounds.x, textBounds.y, w, borderThinkness);
		border.drawRectangle(textBounds.x, textBounds.y + h - borderThinkness, w, borderThinkness);
		border.drawRectangle(textBounds.x, textBounds.y + borderThinkness, borderThinkness, h - (borderThinkness * 2));
		border.drawRectangle(textBounds.x + w - borderThinkness, textBounds.y + borderThinkness, borderThinkness, h - (borderThinkness * 2));
	}
	
	private function set_showBorder(value:Bool):Bool
	{
		return border.visible = value;
	}
}