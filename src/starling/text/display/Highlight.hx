package starling.text.display;

import starling.text.TextDisplay;
import starling.text.model.layout.Char;
import starling.text.model.layout.Line;
import starling.display.Canvas;
import starling.display.DisplayObjectContainer;
import starling.events.Event;
import starling.events.TextDisplayEvent;

/**
 * ...
 * @author P.J.Shand
 */
class Highlight extends DisplayObjectContainer
{
	@:isVar public var highlightAlpha(get, set):Float = 0.5;
	@:isVar public var highlightColour(get, set):UInt = 0x0000FF;
	
	private var canvas:Canvas;
	private var textDisplay:TextDisplay;
	
	@:allow(starling.text)
	private function new(textDisplay:TextDisplay)
	{
		super();
		this.textDisplay = textDisplay;
		
		textDisplay.selection.addEventListener(Event.SELECT, OnSelectionChange);
		textDisplay.charLayout.addEventListener(Event.CHANGE, OnSelectionChange);
		textDisplay.addEventListener(TextDisplayEvent.FOCUS_CHANGE, OnFocusChange);
		
	}
	
	private function OnFocusChange(e:Event):Void 
	{
		if (textDisplay != TextDisplay.focus) {
			if (canvas != null) {
				canvas.clear();
			}
		}
	}
	
	private function OnSelectionChange(e:Event):Void 
	{
		updateDisplay();
	}
	
	public function updateDisplay() 
	{
		if (canvas != null) {
			canvas.clear();
		}
		
		if (textDisplay.selection.begin == null || textDisplay.selection.begin == textDisplay.selection.end){
			return;
		}
		
		var beginChar:Char = textDisplay.charLayout.getCharOrEnd(textDisplay.selection.begin);
		var endChar:Char = textDisplay.charLayout.getCharOrEnd(textDisplay.selection.end);
		
		if (canvas == null) {
			canvas = new Canvas();
			//canvas.alpha = 0.5;
			addChild(canvas);
		}
		
		canvas.beginFill(textDisplay.highlightColour, textDisplay.highlightAlpha);
		
		var len:Int = (endChar.lineNumber - beginChar.lineNumber + 1);
		for (i in 0...len) 
		{
			var lineIndex:Int = beginChar.line.index + i;
			var line:Line = textDisplay.charLayout.getLine(lineIndex);
			if (textDisplay.maxLines != null && line.index >= textDisplay.maxLines) return;
			//if (line.outsizeBounds) return;
			
			var rectX = line.x;
			var rectY = line.y;
			var rectW = line.width;
			var rectH = line.height;
			if (i == 0 && i == len-1) {
				rectX = beginChar.x;
				rectW = endChar.x - rectX;
				
			}
			else if (i == 0) {
				rectX = beginChar.x;
				rectW = line.width - rectX + line.x;
			}
			else if (i == len-1) {
				rectW = endChar.x - line.x;
			}
			canvas.drawRectangle(rectX, rectY, rectW, rectH);
		}
	}
	
	function get_highlightAlpha():Float 
	{
		return highlightAlpha;
	}
	
	function set_highlightAlpha(value:Float):Float 
	{
		highlightAlpha = value;
		updateDisplay();
		return highlightAlpha;
	}
	
	function get_highlightColour():UInt 
	{
		return highlightColour;
	}
	
	function set_highlightColour(value:UInt):UInt 
	{
		highlightColour = value;
		updateDisplay();
		return highlightColour;
	}
}