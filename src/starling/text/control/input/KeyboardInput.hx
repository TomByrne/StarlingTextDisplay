package starling.text.control.input;

import com.imagination.delay.Delay;
import com.imagination.util.signals.Signal.Signal0;
import com.imagination.util.signals.Signal.Signal1;
import openfl.ui.Keyboard;
import starling.text.model.layout.CharLayout;
import starling.text.model.selection.Selection;
import openfl.desktop.Clipboard;
import openfl.desktop.ClipboardFormats;
import starling.events.KeyboardEvent;
import starling.core.Starling;
import starling.text.TextDisplay;

/**
 * ...
 * @author P.J.Shand
 */
class KeyboardInput
{
	private var textDisplay:TextDisplay;
	private var selection:Selection;
	
	private var _active:Null<Bool> = null;
	public var active(get, set):Null<Bool>;
	
	#if js
	var uppercaseRegEx:EReg = ~/[A-Z]/;
	var jsCapsLock = new JSCapsLock();
	#end
	
	@:allow(starling.text)
	private function new(textDisplay:TextDisplay)
	{
		this.textDisplay = textDisplay;
		this.selection = textDisplay.selection;
	}
	
	private function OnKeyDown(e:KeyboardEvent):Void 
	{
		if (e.isDefaultPrevented()) return;
		
		//trace(e.charCode+" "+e.keyCode);
		if (e.keyCode == Keyboard.DELETE) delete();
		else if (e.keyCode == Keyboard.BACKSPACE) backspace();
		else if (e.charCode == 118 && e.ctrlKey) paste();
		else if (e.charCode == 99 && e.ctrlKey) copy();
		else if (e.charCode == 120 && e.ctrlKey) cut();
		else if (e.charCode == 97  && e.ctrlKey) selectAll();
		else if (e.charCode != 0 && !e.ctrlKey && !e.altKey) {
			#if js
				jsCapsLock.check();
				Delay.nextFrame(DelayInput, [e]);
			#else
				addChars(String.fromCharCode(e.charCode));
			#end
		}
	}
	
	#if js
	function DelayInput(e:KeyboardEvent) 
	{
		var char:String = String.fromCharCode(e.charCode);
		if (jsCapsLock.isOn()) {
			var isUppercase:Bool = uppercaseRegEx.match(char);
			if (isUppercase) char = char.toLowerCase();
			else char = char.toUpperCase();
		}
		addChars(char);
	}
	#end
	
	function selectAll() 
	{
		selection.set(0, textDisplay.value.length, 0);
	}
	
	private function paste():Void 
	{
		#if !js
		var pasteStr:String = Clipboard.generalClipboard.getData(ClipboardFormats.TEXT_FORMAT);
		if (pasteStr != null){
			addChars(pasteStr);
		}
		#end
	}
	
	private function copy():Void 
	{
		#if !js
		if (selection.begin != null) {
			var value:String = textDisplay.value.substring(selection.begin, selection.end);
			Clipboard.generalClipboard.clear();
			Clipboard.generalClipboard.setData(ClipboardFormats.TEXT_FORMAT, value);
		}
		#end
	}
	
	private function cut():Void 
	{
		if (selection.begin != null) {
			copy();
			textDisplay.clearSelected();
		}
	}
	
	private function backspace():Void
	{
		textDisplay.clearSelected(0);
	}
	
	private function delete():Void
	{
		if (selection.begin != null) {
			textDisplay.clearSelected();
		}
		else {
			textDisplay.clearSelected(1);
		}
	}
	
	private function addChars(newChars:String):Void 
	{
		if (selection.begin != null) {
			textDisplay.clearSelected();
		}
		
		if(selection.index == -1){
			textDisplay.add(newChars, 0);
			selection.index = newChars.length;
		}else{
			textDisplay.add(newChars, selection.index);
		}
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
			textDisplay.addEventListener(KeyboardEvent.KEY_DOWN, OnKeyDown);
		}
		else {
			textDisplay.removeEventListener(KeyboardEvent.KEY_DOWN, OnKeyDown);
		}
		
		return _active;
	}
}