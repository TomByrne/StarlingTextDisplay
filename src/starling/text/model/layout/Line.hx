package starling.text.model.layout;

import starling.text.model.layout.Char;
import starling.utils.SpecialChar;

/**
 * ...
 * @author P.J.Shand
 */
class Line
{
	public var index:Int;
	public var _height:Float = 9;
	public var height(get, null):Float;
	
	private var _width:Float = 0;
	public var width(get, null):Float;
	public var y:Float = 0;
	public var x:Float = 0;
	public var chars = new Array<Char>();
	public var validJustify(get, null):Bool;
	
	private var _largestChar:Char;
	public var largestChar(get, null):Char;
	public var leading(get, null):Float;
	//public var outsizeBounds:Bool = false; // Needs a bit of a rethink
	public var visible:Bool = true;
	
	@:isVar public var isEmptyLine(get, null):Bool;
	
	public function new() { }	
	
	function get_height():Float 
	{
		return _height;
	}
	
	public function calcHeight():Void 
	{
		_height = largestChar.getLineHeight();
	}
	
	function get_validJustify():Bool 
	{
		var char:Char = chars[chars.length - 1];
		if (SpecialChar.isLineBreak(char.character)) return false;
		return true;
	}
	
	function get_leading():Float
	{
		var _v:Float = Math.NEGATIVE_INFINITY;
		for (j in 0...chars.length) 
		{
			var char:Char = chars[j];
			if (char.format.leading == null) continue;
			if (_v < char.format.leading && !char.isEndChar) {
				_v = char.format.leading;
			}
		}
		if (_v == Math.NEGATIVE_INFINITY) _v = 0;
		return _v;
	}
	
	function get_largestChar():Char 
	{
		for (j in 0...chars.length) 
		{
			var char:Char = chars[j];
			if (char.isEndChar) continue;
			
			if (_largestChar == null) {
				_largestChar = char;
			}
			else if (_largestChar.getLineHeight() < char.getLineHeight()) {
				_largestChar = char;
			}
		}
		if (_largestChar == null) _largestChar = chars[0];
		return _largestChar;
	}
	
	function get_width():Float 
	{
		var v:Float = 0;
		var validChar:Bool = false;
		var lastKerning:Null<Float> = null;
		for (i in 0...chars.length) 
		{
			var char = chars[i];
			if (!SpecialChar.isWhitespace(char.character)) validChar = true;
			if (validChar && char.bitmapChar != null) {
				v += char.bitmapChar.xAdvance * char.scale;
				lastKerning = char.format.kerning;
				if (lastKerning != null) v += lastKerning;
			}
		}
		if (lastKerning != null) v -= lastKerning;
		return v;
	}
	
	function get_isEmptyLine():Bool 
	{
		for (i in 0...chars.length) 
		{
			if (!SpecialChar.isWhitespace(chars[i].character)) return false;
		}
		return true;
	}
}