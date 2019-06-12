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
@:allow(starling.text)
class ClipMask extends Quad
{
	static inline var SIZE:Float = 100;

	var textDisplay:TextDisplay;

	function new(textDisplay:TextDisplay) 
	{
		super(SIZE, SIZE, 0xFFFF00FF);
		this.textDisplay = textDisplay;
		
		textDisplay.charLayout.boundsChanged.add(updateMask);
		textDisplay.alignment.addEventListener(Event.CHANGE, updateMask);
		updateMask();
	}
	
	function updateMask():Void 
	{
		// Setting scaleX/scaleY is much more performant than width/height
		this.scaleX = textDisplay.targetWidth / SIZE;
		this.scaleY = textDisplay.targetHeight / SIZE;
		//this.width = textDisplay.targetWidth;
		//this.height = textDisplay.targetHeight;

		var bounds = textDisplay.textBounds;
		
		if (textDisplay.clipOverflow && (bounds.width > textDisplay.width || bounds.height > textDisplay.height)) {
			this.visible = true;
			textDisplay.mask = this;
		}
		else {
			this.visible = false;
			textDisplay.mask = null;
		}
	}
}