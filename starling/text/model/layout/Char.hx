package starling.text.model.layout;

import starling.text.BitmapChar;
import starling.text.BitmapFont;
import starling.text.model.format.InputFormat;
import starling.text.model.format.CharFormat;

using Logger;

/**
 * ...
 * @author P.J.Shand
 */
class Char
{
	public var x:Float = 0;
	public var y:Float = 0;
	public var width(get, null):Float = 0;
	public var height(get, null):Float = 0;
	public var lineNumber:Int = 0;
	public var charLinePositionX:Int = 0;
	
	public var character:String;
	public var id:Int;
	public var index:Int;
	public var line:Line;
	
	public var scale(get, null):Float;
	
	public var charFormat:CharFormat;
	public var visible:Bool = true;
	
	@:allow(starling.text.model.layout.Line)
	@:allow(starling.text.model.layout.CharLayout)
	private var isEndChar:Bool = false;
	
	public function new(character:String, index:Int=0) 
	{
		this.id = character.charCodeAt(0);
		this.character = character;
		this.index = index;
	}
	
	public function toString():String
	{
		return "(" + character + ", " + id + ", " + x + ")";
	}
	
	function get_width():Float 
	{
		if (charFormat == null) return 0;
		if (charFormat.bitmapChar == null) return 0;
		return return charFormat.bitmapChar.width * scale;
	}
	
	function get_height():Float 
	{
		if (charFormat == null) return 0;
		if (charFormat.bitmapChar == null) return 0;
		return return charFormat.bitmapChar.height * scale;
	}
	
	function get_scale():Float 
	{
		
		if (charFormat.format.size == null){
			return 1;
		}else{
			return charFormat.format.size / charFormat.font.size;
		}
	}
	
	public function getLineHeight():Float 
	{
		if (charFormat == null) return 0;
		if (charFormat.font == null) return 0;
		return charFormat.font.baseline * scale;
	}
	
	function get_format():InputFormat 
	{
		return charFormat.format;
	}
	
	function get_bitmapChar():BitmapChar 
	{
		return charFormat.bitmapChar;
	}
}