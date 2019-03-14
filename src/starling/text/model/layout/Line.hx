package starling.text.model.layout;

import starling.text.model.layout.Char;

/**
 * ...
 * @author P.J.Shand
 */
class Line
{
	public var index:Int;
	
	private var _height:Float = 9;
	public var height(get, null):Float;
	
	private var _totalWidth:Float = 0;
	public var totalWidth(get, null):Float;
	
	private var _boundsWidth:Float = 0;
	public var boundsWidth(get, null):Float;
    
	public var right(get, null):Float;
	
	private var _rise:Float;
	public var rise(get, null):Float;
	
	private var _fall:Float;
	public var fall(get, null):Float;
	
	private var _leading:Float;
	public var leading(get, null):Float;
	
	private var _paddingTop:Float;
	public var paddingTop(get, null):Float;
	
	private var _paddingBottom:Float;
	public var paddingBottom(get, null):Float;
	
	public var y:Float = 0;
	public var x:Float = 0;
	public var chars = new Array<Char>();
	public var validJustify(get, null):Bool;
	
	public var visible:Bool = true;
	
	@:isVar public var isEmptyLine(get, null):Bool;
	
	public function new() { }	
	
	public function setMetrics(lineHeight:Float, rise:Float, fall:Float, leading:Float, paddingTop:Float, paddingBottom:Float) 
	{
		_height = rise - fall;
		_rise = rise;
		_fall = fall;
		_leading = leading;
		_paddingTop = paddingTop;
		_paddingBottom = paddingBottom;
	}
	
	function get_height():Float 
	{
		return _height;
	}
	
	function get_rise():Float 
	{
		return _rise;
	}
	
	function get_fall():Float 
	{
		return _fall;
	}
	
	function get_leading():Float 
	{
		return _leading;
	}
	
	function get_paddingTop():Float 
	{
		return _paddingTop;
	}
	
	function get_paddingBottom():Float 
	{
		return _paddingBottom;
	}
	
	function get_validJustify():Bool 
	{
        if(chars.length < 2) return false;
		var char:Char = chars[chars.length - 1];
        if (char.isEndChar) return false;
		if (char.isLineBreak) return false;
		return true;
	}
	
	function get_totalWidth():Float 
	{
		return _totalWidth;
	}
	
	function get_boundsWidth():Float 
	{
		return _boundsWidth;
	}
	
	function get_right():Float 
	{
		return x + _boundsWidth;
	}
	
	function get_isEmptyLine():Bool 
	{
		for (i in 0...chars.length) 
		{
			if (!chars[i].isWhitespace) return false;
		}
		return true;
	}

    public function calcDimensions()
    {
		/*var x:Float = 0;
		var width:Float = 0;

		var validChar:Bool = false;
        var whiteChars:Float = 0;
		for (i in 0...chars.length) 
		{
			var char = chars[i];
			if (char.bitmapChar != null) {
                var isWhitespace = char.isWhitespace;
			    if (!isWhitespace) validChar = true;
                var charSize:Float = char.bitmapChar.xAdvance * char.scale;
                if(i < chars.length - 1) charSize += char.format.kerning;
				if(validChar){
                    width += charSize;
                    if(isWhitespace){
                        whiteChars += charSize;
                    }else{
                        whiteChars = 0;
                    }
                }else{
                    x += charSize;
                }
			}
		}
        this.x = x;
        _width = width - whiteChars;*/
        
        var firstBoundsChar:Char = null;
        var lastBoundsChar:Char = null;
        var lastValidChar:Char = null;
		for (i in 0...chars.length) 
		{
			var char = chars[i];
            if(char.bitmapChar == null || char.spaceAsLineBreak) continue;

            lastValidChar = char;

            if(!char.isWhitespace)
            {
                if(firstBoundsChar == null) firstBoundsChar = char;
                lastBoundsChar = char;
            }
        }
        if(lastValidChar == null){
            _totalWidth = 0;
        }else{
            var lastX:Float = lastValidChar.x - (lastValidChar.bitmapChar.xOffset * lastValidChar.scale);
            _totalWidth = (lastX + lastValidChar.format.kerning + lastValidChar.bitmapChar.xAdvance * lastValidChar.scale);
        }

        if(firstBoundsChar == null){
            x = 0;
            _boundsWidth = 0;
        }else{
            x = firstBoundsChar.x - (firstBoundsChar.bitmapChar.xOffset * firstBoundsChar.scale);
            var lastX:Float = lastBoundsChar.x - (lastBoundsChar.bitmapChar.xOffset * lastBoundsChar.scale);
            _boundsWidth = (lastX + lastBoundsChar.format.kerning + lastBoundsChar.bitmapChar.xAdvance * lastBoundsChar.scale) - x;
        }
    }
}