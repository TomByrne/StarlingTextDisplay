package starling.text.util;

import starling.text.model.format.FontRegistry;
import starling.text.model.format.CharFormat;
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
	
	static public function findCharFormat(textDisplay:TextDisplay, char:Char, nodes:Array<FormatNode>):CharFormat
	{
		/*var charFormat:CharFormat = new CharFormat();
		for (i in 0...formatLengths.length) 
		{
			if ((char.index >= formatLengths[i].startIndex || formatLengths[i].startIndex == null) && (char.index <= formatLengths[i].endIndex || formatLengths[i].endIndex == null)) {
				if (formatLengths[i].format.face != null){
					var bitmapFont:BitmapFont = FontRegistry.getBitmapFont(formatLengths[i].format.face);
					trace("FIX");
					//if (bitmapFont == null) bitmapFont = textDisplay.formatModel.miniFont;
					if (bitmapFont != null) charFormat.bitmapChar = bitmapFont.getChar(char.id);
					charFormat.font = bitmapFont;
				}
				InputFormatHelper.copyActiveValues(charFormat.format, formatLengths[i].format);
			}
		}*/
		
		var charFormat:CharFormat = new CharFormat();
		var format = charFormat.format;
		
		if (nodes.length == 0) format = textDisplay.formatModel.defaultFormat;
		else applyFormats(format, char, nodes);
		
		updateCharFormat(format, charFormat, textDisplay.formatModel.defaultFont);
		
		InputFormatHelper.copyMissingValues(format, textDisplay.defaultFormat);
		
		var charID:Int = char.id;
		if (charFormat.format.textTransform == TextTransform.UPPERCASE) {
			charID = String.fromCharCode(charID).toUpperCase().charCodeAt(0);
		}
		else if (charFormat.format.textTransform == TextTransform.LOWERCASE) {
			charID = String.fromCharCode(charID).toLowerCase().charCodeAt(0);
		}
		
		charFormat.bitmapChar = charFormat.font.getChar(charID);
		
		return charFormat;
	}
	
	static public function updateCharFormat(format:InputFormat, charFormat:CharFormat, defaultFont:BitmapFont):CharFormat
	{
		charFormat.format = format;
		if (format.face != null) charFormat.font = FontRegistry.getBitmapFont(format.face/*, cast format.size*/);
		if (charFormat.font == null) charFormat.font = defaultFont;
		return charFormat;
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