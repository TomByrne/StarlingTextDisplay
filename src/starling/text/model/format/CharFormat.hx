package starling.text.model.format;

import starling.text.BitmapChar;
import starling.text.model.format.InputFormat;

/**
 * ...
 * @author P.J.Shand
 */
class CharFormat
{
	public var bitmapChar:BitmapChar;
	public var font:BitmapFont;
	private var _format:InputFormat = new InputFormat();
	public var format(get, set):InputFormat;
	
	public function new() 
	{
		
	}
	
	function get_format():InputFormat
	{
		return _format;
	}
	
	function set_format(value:InputFormat):InputFormat
	{
		return _format = value;
	}
	
}