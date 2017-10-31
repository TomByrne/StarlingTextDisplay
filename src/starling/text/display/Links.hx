package starling.text.display;
import starling.display.Sprite;
import starling.text.util.FormatParser.FormatAttribute;
import starling.text.util.FormatParser.FormatNode;

/**
 * ...
 * @author P.J.Shand
 */
class Links extends Sprite 
{
	var textDisplay:TextDisplay;

	@:allow(starling.text)
	private function new(textDisplay:TextDisplay) 
	{
		super();
		this.textDisplay = textDisplay;
	}
	
	override public function dispose():Void
	{
		super.dispose();
	}
	
	public function update() 
	{
		for (i in 0...textDisplay.contentModel.nodes.length) 
		{
			var node:FormatNode = textDisplay.contentModel.nodes[i];
			for (j in 0...node.attributes) 
			{
				var attribute:FormatAttribute = node.attributes[j];
				if (attribute.key == "href") {
					trace("attribute = " + attribute.value);
					trace([node.startIndex, node.endIndex]);
				}
			}
		}
	}
}