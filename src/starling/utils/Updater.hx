package starling.utils;

import com.imagination.util.time.EnterFrame;

/**
 * Creates an update loop.
 * Used to collate changes to recalculate/redraw on the next frame.
 * 
 * @author Thomas Byrne
 */
class Updater
{
	public var heirarchyDepth:Int = 0;
	public var active(default, set):Bool = true;
	public var pendingUpdate(get, null):Bool = false;
	
	var updateHandler:Void->Void;

	public function new(updateHandler:Void->Void) 
	{
		this.updateHandler = updateHandler;
	}
	
	public function markForUpdate() 
	{
		if (pendingUpdate) return;
		pendingUpdate = true;
		if(active) EnterFrame.signal.addOnceWithPriority(doUpdate, -heirarchyDepth);
	}
	
	function doUpdate() 
	{
		if (!active) return;
		pendingUpdate = false;
		updateHandler();
	}
	
	public function triggerUpdate(?force:Bool) : Void
	{
		if (!force && !pendingUpdate) return;
		
		if (pendingUpdate) {
			pendingUpdate = false;
			EnterFrame.remove(doUpdate);
		}
		updateHandler();
	}
	
	function set_active(value:Bool):Bool 
	{
		if(active == value) return value;
		active = value;
		if (value) triggerUpdate();
		return value;
	}
	
	function get_pendingUpdate():Bool 
	{
		return pendingUpdate;
	}
}