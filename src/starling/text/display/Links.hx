package starling.text.display;
import openfl.Vector;
import openfl.geom.Point;
import starling.display.Sprite;
import starling.events.LinkEvent;
import starling.events.Touch;
import starling.events.TouchEvent;
import starling.events.TouchPhase;
import starling.text.model.layout.Char;
import starling.text.util.FormatParser.FormatNode;

/**
 * ...
 * @author P.J.Shand
 */
class Links extends Sprite 
{
	var textDisplay:TextDisplay;
	var links:Array<Link> = [];
	
	@:allow(starling.text)
	private function new(textDisplay:TextDisplay) 
	{
		this.textDisplay = textDisplay;
		super();
		
		update();
	}
	
	override public function dispose():Void
	{
		super.dispose();
	}
	
	public function update() 
	{
		textDisplay.hitArea.removeEventListener(TouchEvent.TOUCH, OnTouch);
		links = [];
		
		createLinks(textDisplay.contentModel.nodes);
		
		if (links.length > 0) {
			textDisplay.touchable = true;
			textDisplay.hitArea.addEventListener(TouchEvent.TOUCH, OnTouch);
		}
	}
	
	private function OnTouch(e:TouchEvent):Void 
	{
		var beginTouches:Vector<Touch> = e.getTouches(untyped e.target, TouchPhase.BEGAN);
		for (i in 0...beginTouches.length) 
		{
			checkPosition(beginTouches[i].globalX, beginTouches[i].globalY);
		}
	}
	
	function checkPosition(_x:Float, _y:Float) 
	{
		var pos:Point = textDisplay.globalToLocal(new Point(_x, _y));
		var char:Char = textDisplay.charLayout.getCharByPosition(pos.x, pos.y);
		
		for (i in 0...links.length) 
		{
			if (char.index >= links[i].startIndex && char.index < links[i].endIndex) {
				textDisplay.dispatchEvent(new LinkEvent(LinkEvent.CLICK, links[i].href));
			}
		}
	}
	
	function createLinks(formatNodes:Array<FormatNode>) 
	{
		if (formatNodes == null) return;
		
		for (i in 0...formatNodes.length) 
		{
			var node:FormatNode = formatNodes[i];
			
			/*for (j in 0...node.attributes.length) 
			{
				var attribute:FormatAttribute = node.attributes[j];
				if (attribute.key == "href") {
					addLinkRange(attribute.value, node.startIndex, node.endIndex);
				}
			}*/
			
			if (node.format.href != null) {
				addLinkRange(node.format.href, node.startIndex, node.endIndex);
			}
			
			createLinks(node.children);
		}
	}
	
	function addLinkRange(href:String, startIndex:Int, endIndex:Int) 
	{
		links.push( { href:href, startIndex:startIndex, endIndex:endIndex } );
	}
}

typedef Link =
{
	href:String,
	startIndex:Int, 
	endIndex:Int
}