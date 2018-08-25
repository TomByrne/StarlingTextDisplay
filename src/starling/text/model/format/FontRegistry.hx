package starling.text.model.format;
import starling.core.Starling;
import starling.text.BitmapFont;

/**
 * ...
 * @author Thomas Byrne
 */
class FontRegistry
{
	// the name container with the registered bitmap fonts
	private static var BITMAP_FONT_DATA_NAME:String = "starling.display.TextField.BitmapFonts";
	
	
	private static var bitmapFonts/*(get, null)*/:Map<String, BitmapFont> = new Map();
	//private static var fontFamilys = new Map<String, FontFamily>();
	
	
	/** Makes a bitmap font available at any TextField in the current stage3D context.
	 *  The font is identified by its <code>name</code> (not case sensitive).
	 *  Per default, the <code>name</code> property of the bitmap font will be used, but you 
	 *  can pass a custom name, as well. @return the name of the font. */
	public static function registerBitmapFont(bitmapFont:BitmapFont, name:String=null/*, size:Null<Int>=null*/):String
	{
		if (name == null) name = bitmapFont.name + "_" +bitmapFont.size;
		name = name.toLowerCase();
		bitmapFonts[name.toLowerCase()] = bitmapFont;
		/*if (!fontFamilys.exists(name)) {
			fontFamilys[name] = new FontFamily();
		}
		fontFamilys[name].add(size, bitmapFont);*/
		return name;
	}
	
	/** Unregisters the bitmap font and, optionally, disposes it. */
	public static function unregisterBitmapFont(/*size:Int, */name:String, dispose:Bool=true):Void
	{
		name = name.toLowerCase();
		
		if (dispose && !bitmapFonts.exists(name)){
			bitmapFonts[name].dispose();
			//fontFamilys[name].remove(size);
		}
		
		bitmapFonts.remove(name);
	}
	
	/** Returns a registered bitmap font (or null, if the font has not been registered). 
	 *  The name is not case sensitive. */
	public static function getBitmapFont(name:String):BitmapFont
	{
		/*var fontFamily:FontFamily = fontFamilys[name.toLowerCase()];
		if (fontFamily == null) return null;
		return fontFamily.closest(size);
		*/
		if (name == null) return null;
		var font:BitmapFont = bitmapFonts.get(name);
		if(font == null) font = bitmapFonts.get(name.toLowerCase());
		return font;
	}
	
	public static function findBitmapName(name:String, size:Float):String
	{
		/*if (bitmapFonts.exists(name)){
			return bitmapFonts.get(name).name;
		}*/
		var name = name.toLowerCase();
		var bestFit:String = null;
		var bestDif:Float = 0;
		for (regName in bitmapFonts.keys())
		{
			if (regName.indexOf(name+"_") != 0) continue;
			
			var bitmapFont = bitmapFonts.get(regName);
			var dif:Float = Math.abs(bitmapFont.size - size);
			if (bestFit == null || dif < bestDif)
			{
				bestDif = dif;
				bestFit = regName;
			}
		}
		return bestFit;
	}
	
	/*public static function getBitmapName(name:String, ?size:Null<Int>):String
	{
		var name = name.toLowerCase();
		if (size != null) name += "_" + size;
		return name;
	}*/
	
	/** Stores the currently available bitmap fonts. Since a bitmap font will only work
	 *  in one Stage3D context, they are saved in Starling's 'contextData' property. */
	/*private static function get_bitmapFonts():Map<String, BitmapFont>
	{
		var fonts:Map<String, BitmapFont> = cast Starling.current.contextData[BITMAP_FONT_DATA_NAME];
		
		if (fonts == null)
		{
			fonts = new Map<String, BitmapFont>();
			//Starling.current.contextData[BITMAP_FONT_DATA_NAME] = fonts;
		}
		
		return fonts;
	}*/
	
}
/*
class FontFamily
{
	public var sizes:Array<BitmapFont> = [];
	
	public function new() { }

	public function add(size:Int, font:BitmapFont):Void
	{
		for (i in 0...sizes.length) 
		{
			if (sizes[i].size == size) return; 
		}
		sizes.push(font);
		
		if (sizes.length > 1){
			sizes.sort(function(b1:BitmapFont, b2:BitmapFont):Int
			{
				if (b1.size > b2.size) return 1;
				else if (b1.size < b2.size) return -1;
				else return 0;
			});
		}
	}
	
	public function remove(size:Int):Void
	{
		for (i in 0...sizes.length) 
		{
			if (sizes[i].size == size) {
				sizes.splice(i, 1);
				return; 
			}
		}
	}
	
	public function closest(size:Int):BitmapFont
	{
		if (sizes.length == 0) return null;
		
		var index:Int = 0;
		var j:Int = sizes.length - 1;
		while (j >= 0)
		{
			if (size <= sizes[j].size) {
				index = j;
			}
			j--;
		}
		return sizes[index];
	}
}*/