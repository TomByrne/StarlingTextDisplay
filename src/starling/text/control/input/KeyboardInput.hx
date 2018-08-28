package starling.text.control.input;

import com.imagination.util.signals.Signal.Signal0;
import com.imagination.util.signals.Signal.Signal1;
import com.imagination.util.time.EnterFrame;
import openfl.system.Capabilities;
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
@:access(starling.text.TextDisplay)
@:access(starling.text.model.history.HistoryModel)
class KeyboardInput
{
	#if js
	static var uppercaseRegEx:EReg = ~/[A-Z]/;
	static var jsCapsLock = new JSCapsLock();
	static var jsCopyPaste = new JSCopyPaste();
	#end
	
	private var textDisplay:TextDisplay;
	private var selection:Selection;
	
	private var _active:Null<Bool> = null;
	public var active(get, set):Null<Bool>;
	
	@:allow(starling.text)
	private function new(textDisplay:TextDisplay)
	{
		this.textDisplay = textDisplay;
		this.selection = textDisplay.selection;
	}
	
	private function OnKeyDown(e:KeyboardEvent):Void 
	{
		if (e.isDefaultPrevented()) return;
		
		if (e.altKey){
			if (Capabilities.os.indexOf("Mac") !=-1){
				// Mac shortcuts
				if (e.keyCode == Keyboard.NUMBER_2 || e.keyCode == Keyboard.NUMPAD_2) textDisplay.replaceSelection(String.fromCharCode(8482)); // Trademark
				else if (e.keyCode == Keyboard.G) textDisplay.replaceSelection(String.fromCharCode(169)); // Copyright
				else if (e.keyCode == Keyboard.R) textDisplay.replaceSelection(String.fromCharCode(174)); // Registered
			}else{
				// Windows Shortcuts
				if (e.ctrlKey && e.keyCode == Keyboard.T) textDisplay.replaceSelection(String.fromCharCode(8482)); // Trademark
				else if (e.ctrlKey && e.keyCode == Keyboard.C) textDisplay.replaceSelection(String.fromCharCode(169)); // Copyright
				else if (e.ctrlKey && e.keyCode == Keyboard.R) textDisplay.replaceSelection(String.fromCharCode(174)); // Registered
			}
			
		}else{
			if (e.keyCode == Keyboard.DELETE) delete();
			else if (e.keyCode == Keyboard.BACKSPACE) backspace();
			else if (e.keyCode == Keyboard.ESCAPE) ignore();
			else if (!textDisplay.allowLineBreaks && e.keyCode == Keyboard.ENTER) ignore();
			
			else if (e.charCode == 118 && e.ctrlKey) paste();
			else if (e.charCode == 99 && e.ctrlKey) copy();
			else if (e.charCode == 120 && e.ctrlKey) cut();
			else if (e.charCode == 97  && e.ctrlKey) selectAll();
			else if (e.charCode != 0 && !e.ctrlKey) {
				#if js
					jsCapsLock.check();
					EnterFrame.delay(DelayInput.bind(e));
				#else
					textDisplay.replaceSelection(String.fromCharCode(e.charCode));
				#end
			}
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
		textDisplay.replaceSelection(char);
	}
	#end
	
	function selectAll() 
	{
		selection.set(0, textDisplay.value.length, 0);
	}
	
	private function paste():Void 
	{
		trace("paste");
		#if !js
		var pasteStr:String = Clipboard.generalClipboard.getData(ClipboardFormats.TEXT_FORMAT);
		if (pasteStr != null){
			textDisplay.replaceSelection(pasteStr);
		}
		#end
	}
	
	private function copy():Void 
	{
		trace("copy");
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
	
	private function ignore():Void
	{
		// ignore
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
	
	function get_active():Null<Bool> 
	{
		return _active;
	}
	
	function set_active(value:Null<Bool>):Null<Bool> 
	{
		if (_active == value) return value;
		_active = value;
		
		if (_active) {
			#if js
				jsCopyPaste.focusedTextDisplay = textDisplay;
			#end
			textDisplay.addEventListener(KeyboardEvent.KEY_DOWN, OnKeyDown);
		}
		else {
			#if js
				if(jsCopyPaste.focusedTextDisplay == textDisplay) jsCopyPaste.focusedTextDisplay = null;
			#end
			textDisplay.removeEventListener(KeyboardEvent.KEY_DOWN, OnKeyDown);
		}
		
		return _active;
	}
}