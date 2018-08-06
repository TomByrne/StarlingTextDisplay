package starling.text.display;

import com.imagination.util.time.EnterFrame;
import starling.display.Quad;
import starling.events.Event;

#if starling2

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
		
		textDisplay.addEventListener(TextDisplayEvent.SIZE_CHANGE, UpdateMark);
		textDisplay.addEventListener(Event.CHANGE, UpdateMark);
		textDisplay.alignment.addEventListener(Event.CHANGE, UpdateMark);
		UpdateMark(null);
	}
	
	private function UpdateMark(e:Event):Void 
	{
		Update();
		EnterFrame.delay(Update, 2);
	}
	
	public function Update():Void 
	{
		this.width = textDisplay.width;
		this.height = textDisplay.height;
		if (textDisplay.charLayout.lines.length > 0) {
			var lastLineHeight:Float = textDisplay.charLayout.lines[textDisplay.charLayout.lines.length - 1].height;
			this.height += lastLineHeight;
		}
		
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