package starling.text.util;

import starling.text.model.format.FontRegistry;
import starling.text.model.format.InputFormat;
import starling.text.model.format.TextTransform;
import starling.text.model.layout.Char;
import starling.text.util.FormatParser.FormatNode;

/**
 * ...
 * @author P.J.Shand
 */
class CharacterHelper
{

	public function new() 
	{
		
	}
	
	static public function findCharFormat(textDisplay:TextDisplay, char:Char, nodes:Array<FormatNode>):Void
	{
		var format = char.format;
		
		if (nodes.length == 0) format = textDisplay.formatModel.defaultFormat;
		else applyFormats(format, char, nodes);
		
		updateCharFormat(format, char, textDisplay.formatModel.defaultFont);
		
		InputFormatHelper.copyMissingValues(format, textDisplay.defaultFormat);
		
		var charID:Int = char.id;
		if (char.format.textTransform == TextTransform.UPPERCASE) {
			charID = String.fromCharCode(charID).toUpperCase().charCodeAt(0);
		}
		else if (char.format.textTransform == TextTransform.LOWERCASE) {
			charID = String.fromCharCode(charID).toLowerCase().charCodeAt(0);
		}
		
		char.bitmapChar = char.font.getChar(charID);
	}
	
	static public function updateCharFormat(format:InputFormat, char:Char, defaultFont:BitmapFont):Void
	{
		char.format = format;
		if (format.face != null){
			char.font = FontRegistry.getBitmapFont(format.face);
			if(char.font == null) char.font = FontRegistry.getBitmapFont(FontRegistry.findBitmapName(format.face, cast format.size));
		}
		if (char.font == null) char.font = defaultFont;
	}
	
	static private function applyFormats(format:InputFormat, char:Char, nodes:Array<FormatNode>) 
	{
		for (j in 0...nodes.length) 
		{
			if (char.index >= nodes[j].startIndex && char.index <= nodes[j].endIndex){
				InputFormatHelper.copyActiveValues(format, nodes[j].format);
			}
			
			if (nodes[j].children.length > 0) {
				applyFormats(format, char, nodes[j].children);
			}
		}
	}
	
}