package starling.text.control.focus;
import starling.core.Starling;
import starling.events.Touch;
import starling.events.TouchEvent;
import starling.events.TouchPhase;

/**
 * ...
 * @author P.J.Shand
 */
@:access(starling.text)
class ClickFocus
{
	private var textDisplay:TextDisplay;

	@:allow(starling.text)
	private function new(textDisplay:TextDisplay) 
	{
		this.textDisplay = textDisplay;
		textDisplay.addEventListener(TouchEvent.TOUCH, onTouch);
	}
	
	private function onTouch(e:TouchEvent):Void 
	{
		if (e.getTouch(textDisplay, TouchPhase.BEGAN) != null){
			haxe.Timer.delay(SetFocus, 1);
		}
	}
	
	function SetFocus() 
	{
		textDisplay.hasFocus = true;
	}
	
	function OnPressStage(touch:Touch) 
	{
		textDisplay.hasFocus = false;
	}
	
}