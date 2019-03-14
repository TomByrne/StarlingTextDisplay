package starling.text.control.focus;
import starling.core.Starling;
import starling.events.*;

/**
 * ...
 * @author P.J.Shand
 */
@:access(starling.text)
class ClickFocus
{
	var textDisplay:TextDisplay;
    var stageListening:Bool;

	@:allow(starling.text)
	private function new(textDisplay:TextDisplay) 
	{
		this.textDisplay = textDisplay;
		textDisplay.addEventListener(TouchEvent.TOUCH, onTouch);
        textDisplay.addEventListener(TextDisplayEvent.FOCUS_CHANGE, onFocusChange);
	}
	
	private function onTouch(e:TouchEvent):Void 
	{
		if (e.getTouch(textDisplay, TouchPhase.BEGAN) != null){
			haxe.Timer.delay(setFocus, 1);
		}
	}
	
	function setFocus() 
	{
        TextDisplay.focus = textDisplay;
	}

    function onFocusChange(e:Event)
    {
        if(textDisplay.hasFocus)
        {
            if(!stageListening){
                stageListening = true;
                textDisplay.root.addEventListener(TouchEvent.TOUCH, onStageTouch);
            }
        }else if(stageListening){
            stageListening = false;
            textDisplay.root.removeEventListener(TouchEvent.TOUCH, onStageTouch);
        }
    }

    function onStageTouch(e:TouchEvent)
    {
        if(e.data == null) return;

        var beganTouch:Touch = e.getTouch(textDisplay.root, TouchPhase.BEGAN);
        if(beganTouch == null) return;

        if(e.getTouch(textDisplay) == null) TextDisplay.focus = null;
    }
	
}