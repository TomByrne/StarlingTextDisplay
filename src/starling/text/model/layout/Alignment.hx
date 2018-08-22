package starling.text.model.layout;

import starling.events.Event;
import starling.events.EventDispatcher;


#if starling2
	import starling.utils.Align;
	typedef HAlign = Align;
	typedef VAlign = Align;
#else
	import starling.utils.HAlign;
	import starling.utils.VAlign;
#end

/**
 * ...
 * @author P.J.Shand
 */
class Alignment extends EventDispatcher
{
	private var textDisplay:TextDisplay;
	
	@:isVar public var hAlign(default, set):String = HAlign.LEFT;
	@:isVar public var vAlign(default, set):String = VAlign.TOP;
	
	@:allow(starling.text)
	private function new(textDisplay:TextDisplay) 
	{
		this.textDisplay = textDisplay;
		super();
	}
	
	function set_vAlign(value:String):String 
	{
		if (value == null) value = VAlign.TOP;
		if (vAlign == value) return value;
		vAlign = value;
		textDisplay.markForUpdate();
		this.dispatchEvent(new Event(Event.CHANGE));
		return vAlign;
	}
	
	function set_hAlign(value:String):String 
	{
		hAlign = value;
		textDisplay.markForUpdate();
		return hAlign;
	}
}