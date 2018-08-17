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
class HitArea extends Quad
{
	private static inline var borderThinkness:Int = 3;
	
	var textDisplay:TextDisplay;
	
	public function new(textDisplay:TextDisplay, width:Float, height:Null<Float>) 
	{
		if (height == null) height = 50;
		
		super(width, height);
		this.textDisplay = textDisplay;
		
		alpha = 0;
		
		textDisplay.charLayout.addEventListener(Event.CHANGE, OnLayoutChange);
		textDisplay.addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
		OnLayoutChange(null);
	}
	
	private function onAddedToStage(e:Event):Void 
	{
		OnLayoutChange(null);
	}
	
	private function OnLayoutChange(e:Event):Void 
	{
		if (textDisplay.stage == null) return;
		
		var w = textDisplay.width;
		var h = textDisplay.height;
		width = (w < 10 ? 10 : w);
		height = (h < 10 ? 10 : h);
	}
}