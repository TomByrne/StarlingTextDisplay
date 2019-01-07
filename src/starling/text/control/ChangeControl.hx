package starling.text.control;
import starling.events.Event;

/**
 * ...
 * @author P.J.Shand
 */
class ChangeControl
{
	private var textDisplay:TextDisplay;

	@:allow(starling.text)
	private function new(textDisplay:TextDisplay) 
	{
		this.textDisplay = textDisplay;
		textDisplay.charLayout.addEventListener(Event.CHANGE, OnCharLayoutChange);
	}
	
	private function OnCharLayoutChange(e:Event):Void 
	{
		textDisplay.charRenderer.render(textDisplay.charLayout.characters);
	}
}