package starling.text.control;

import starling.display.Border;
import starling.display.Quad;
import starling.display.Sprite;
import starling.events.Event;

/**
 * ...
 * @author P.J.Shand
 */
class BoundsControl extends Border
{
	var textDisplay:TextDisplay;
	
	public var showBoundsBorder(get, set):Bool;
	public var showTextBorder(get, set):Bool;
	
	public function new(textDisplay:TextDisplay) 
	{
		super();
		
		this.textDisplay = textDisplay;
		
		textDisplay.charLayout.addEventListener(Event.CHANGE, OnLayoutChange);
	}
	
	
	function createBoundsBorder() 
	{
		if (textDisplay.boundsBorder == null){
			textDisplay.boundsBorder = new Border( 100, 100, 0xFF0000, 1, BorderPosition.CENTER );
			textDisplay.addChild(textDisplay.boundsBorder);
			resizeBoundsBorder();
		}
	}
	
	function createTextBorder() 
	{
		if (textDisplay.textBorder == null){
			textDisplay.textBorder = new Border( 100, 100, 0x00FF00, 1, BorderPosition.CENTER );
			textDisplay.addChild(textDisplay.textBorder);
			resizeTextBorder();
		}
	}
	
	private function OnLayoutChange(e:Event):Void 
	{
		if (textDisplay.textBorder != null) resizeTextBorder();
		if (textDisplay.boundsBorder != null) resizeBoundsBorder();
	}
	
	function resizeBoundsBorder() 
	{
		textDisplay.boundsBorder.width = textDisplay.targetWidth;
		textDisplay.boundsBorder.height = textDisplay.targetHeight;
	}
	
	function resizeTextBorder() 
	{
		textDisplay.textBorder.x = textDisplay.textBounds.x;
		textDisplay.textBorder.y = textDisplay.textBounds.y;
		textDisplay.textBorder.width = textDisplay.textBounds.width;
		textDisplay.textBorder.height = textDisplay.textBounds.height;
	}
	
	function get_showBoundsBorder():Bool 
	{
		if (textDisplay.boundsBorder == null){
			return false;
		}else{
			return textDisplay.boundsBorder.visible;
		}
	}
	function set_showBoundsBorder(value:Bool):Bool 
	{
		if (textDisplay.boundsBorder == null){
			if (value){
				createBoundsBorder();
			}
		}else{
			textDisplay.boundsBorder.visible = value;
		}
		return value;
	}
	
	function get_showTextBorder():Bool 
	{
		if (textDisplay.textBorder == null){
			return false;
		}else{
			return textDisplay.textBorder.visible;
		}
	}
	function set_showTextBorder(value:Bool):Bool 
	{
		if (textDisplay.textBorder == null){
			if (value){
				createTextBorder();
			}
		}else{
			textDisplay.textBorder.visible = value;
		}
		return value;
	}
}