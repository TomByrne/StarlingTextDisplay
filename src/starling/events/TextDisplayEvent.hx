package starling.events;

import starling.events.Event;

/**
 * ...
 * @author Thomas Byrne
 */
class TextDisplayEvent extends Event
{
	public static var SIZE_CHANGE:String = "sizeChange";
	public static var FOCUS_CHANGE:String = "focusChange";
	
	public function new(type:String, bubbles:Bool=false, data:Dynamic=null) 
	{
		super(type, bubbles, data);
		
	}
	
}