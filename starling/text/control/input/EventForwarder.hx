package starling.text.control.input;
import openfl.events.KeyboardEvent;
import starling.core.Starling;
import starling.text.TextDisplay;

import starling.events.KeyboardEvent as StarlingKeyboardEvent;

/**
 * ...
 * @author Thomas Byrne
 */
class EventForwarder
{
	private var _active:Null<Bool> = null;
	public var active(get, set):Null<Bool>;
	
	private var textDisplay:TextDisplay;

	@:allow(starling.text)
	private function new(textDisplay:TextDisplay)
	{
		this.textDisplay = textDisplay;
	}
	
	function get_active():Null<Bool> 
	{
		return _active;
	}
	
	function set_active(value:Null<Bool>):Null<Bool> 
	{
		if (_active == value) return value;
		_active = value;
		
		if (_active) {
			Starling.current.nativeStage.addEventListener(KeyboardEvent.KEY_DOWN, OnKeyEvent);
			Starling.current.nativeStage.addEventListener(KeyboardEvent.KEY_UP, OnKeyEvent);
		}
		else {
			Starling.current.nativeStage.removeEventListener(KeyboardEvent.KEY_DOWN, OnKeyEvent);
			Starling.current.nativeStage.removeEventListener(KeyboardEvent.KEY_UP, OnKeyEvent);
		}
		
		return _active;
	}
	
	private function OnKeyEvent(e:KeyboardEvent):Void 
	{
		textDisplay.dispatchEvent(convertKeyboardEvent(e));
		//e.stopPropagation();
		e.preventDefault();
	}
	
	function convertKeyboardEvent(e:KeyboardEvent) : StarlingKeyboardEvent
	{
		return new StarlingKeyboardEvent(e.type, e.charCode, e.keyCode, e.keyLocation, e.ctrlKey, e.altKey, e.shiftKey);
	}
}