package starling.text.display;

import starling.time.Tick;
import starling.display.Quad;
import starling.events.Event;
import starling.events.TextDisplayEvent;

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
		
		//textDisplay.addEventListener(TextDisplayEvent.SIZE_CHANGE, updateMask);
		textDisplay.addEventListener(Event.RESIZE, updateMask);
		textDisplay.alignment.addEventListener(Event.CHANGE, updateMask);
		updateMask(null);
	}
	
	private function updateMask(e:Event):Void 
	{
		Update();
		Tick.once(Update, 2);
	}
	
	public function Update():Void 
	{
		this.width = textDisplay.targetWidth;
		this.height = textDisplay.targetHeight;
		/*if (textDisplay.charLayout.lines.length > 0) {
			var lastLineHeight:Float = textDisplay.charLayout.lines[textDisplay.charLayout.lines.length - 1].height;
			this.height += lastLineHeight;
		}*/
		
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