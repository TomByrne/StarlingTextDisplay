package starling.text.control.input;

import openfl.events.Event;
import openfl.geom.Rectangle;
import openfl.text.TextField;
import openfl.text.TextFieldType;
import starling.core.Starling;
import starling.events.Event;
import starling.text.TextDisplay;

/**
 * ...
 * @author P.J.Shand
 */
@:access(starling.text)
class SoftKeyboardIO
{
	private var textDisplay:TextDisplay;
	private static var nativeTextField:TextField;
	
	var hasFocus:Bool;

	@:allow(starling.text)
	private function new(textDisplay:TextDisplay)
	{
		this.textDisplay = textDisplay;
		
		if(nativeTextField == null){
			nativeTextField = new TextField();
			nativeTextField.y = -1000000; // place off stage
			nativeTextField.type = TextFieldType.INPUT;
			nativeTextField.needsSoftKeyboard = true;
		}
		
		textDisplay.addEventListener(starling.events.Event.FOCUS_CHANGE, OnFocusChange);
	}
	
	private function OnFocusChange(e:starling.events.Event):Void 
	{
		if (textDisplay.hasFocus == hasFocus) return;
		hasFocus = textDisplay.hasFocus;
		
		if (hasFocus) {
			Starling.current.nativeStage.addChild(nativeTextField);
			nativeTextField.requestSoftKeyboard();
		}else{
			Starling.current.nativeStage.removeChild(nativeTextField);
		}
	}
}