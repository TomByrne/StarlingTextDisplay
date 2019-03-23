package starling.text.display;

import starling.time.Tick;
import starling.display.Quad;
import starling.events.Event;

#if (starling >= "2.0.0")

#else
	import starling.utils.VAlign;
#end


/**
 * ...
 * @author P.J.Shand
 */
class ClipMask extends Quad
{
	var textDisplay:TextDisplay;

	@:allow(starling.text)
	private function new(textDisplay:TextDisplay) 
	{
		super(textDisplay.width, textDisplay.height, 0xFFFF00FF);
		this.textDisplay = textDisplay;
		
		textDisplay.charLayout.boundsChanged.add(updateMask);
		textDisplay.alignment.addEventListener(Event.CHANGE, updateMask);
		updateMask();
	}
	
	private function updateMask():Void 
	{
		update();
		Tick.once(update, 2);
	}
	
	public function update():Void 
	{
		this.width = textDisplay.targetWidth;
		this.height = textDisplay.targetHeight;
		
		if (textDisplay.clipOverflow && (textDisplay.textBounds.width > textDisplay.width || textDisplay.textBounds.height > textDisplay.height)) {
			this.visible = true;
			textDisplay.mask = this;
		}
		else {
			this.visible = false;
			textDisplay.mask = null;
		}
	}
}