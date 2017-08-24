package starling.text;

import starling.events.Event;

/**
 * ...
 * @author Thomas Byrne
 */
class TextDisplayEvent extends Event
{
	public static var SIZE_CHANGE:String = "sizeChange";
	public static var FOCUS:String = "focus";
	
	public function new(type:String, bubbles:Bool=false, data:Dynamic=null) 
	{
		super(type, bubbles, data);
		
	}
	
}