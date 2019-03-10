package starling.text.model.format;

import starling.text.model.format.FontRegistry;
import starling.text.model.format.InputFormat;
import starling.text.model.layout.Char;
import starling.text.util.FormatParser.FormatNode;
import starling.text.util.InputFormatHelper;

/**
 * ...
 * @author P.J.Shand
 */
class FormatModel
{
	@:allow(starling.text) static var baseDefaultFont:BitmapFont;
	
	private var textDisplay:TextDisplay;
	@:allow(starling.text) var defaultFormat:InputFormat;
	@:allow(starling.text) var defaultFont(get, null):BitmapFont;
	
	@:allow(starling.text)
	private function new(textDisplay:TextDisplay) 
	{
		this.textDisplay = textDisplay;

		checkDefaultFont();
		
		var defaultColor:UInt = 0xFFFFFF;
		defaultFormat = new InputFormat(baseDefaultFont.name, 16, defaultColor);
	}

	static function checkDefaultFont()
	{
		if(baseDefaultFont == null){
			baseDefaultFont = new BitmapFont(MiniBitmapFont.texture, MiniBitmapFont.xml);
			FontRegistry.registerBitmapFont(baseDefaultFont);
		}
	}
	
	public function setDefaults(format:InputFormat) 
	{
		InputFormatHelper.copyActiveValues(defaultFormat, format);
	}
	
	function get_defaultFont():BitmapFont 
	{
		var bitmapFont:BitmapFont = FontRegistry.getBitmapFont(defaultFormat.face);
		if (bitmapFont == null) bitmapFont = baseDefaultFont;
		return bitmapFont;
	}
}