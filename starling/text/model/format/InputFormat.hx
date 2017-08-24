package starling.text.model.format;
import starling.text.BitmapFont;

/**
 * ...
 * @author P.J.Shand
 */
class InputFormat
{
	public var size:Null<Float> = 200;
	public var face:Null<String>;
	public var color:Null<UInt> = 0xFFFFFF;
	public var kerning:Null<Float>; // letter spacing
	public var leading:Null<Float>; // line spacing
	public var textTransform:TextTransform;
	
	public function new(?face:String, ?size:Null<Int>, ?color:Null<UInt>, ?kerning:Null<Float>, ?leading:Null<Float>, ?textTransform:TextTransform) 
	{
		this.face = face;
		this.size = size;
		this.color = color;
		this.kerning = kerning;
		this.leading = leading;
		if (textTransform != null) this.textTransform = textTransform;
	}
	
	public function toString():String
	{
		var returnVal:String = "";
		returnVal += "\nface = " + face + "\n";
		returnVal += "size = " + size + "\n";
		returnVal += "color = " + StringTools.hex(color, 6) + "\n";
		returnVal += "kerning = " + kerning + "\n";
		returnVal += "leading = " + leading + "\n";
		returnVal += "textTransform = " + textTransform + "\n";
		return returnVal;
	}
	
	public function clone():InputFormat
	{
		var inputFormat = new InputFormat();
		inputFormat.size = this.size;
		inputFormat.face = this.face;
		inputFormat.color = this.color;
		inputFormat.kerning = this.kerning;
		inputFormat.leading = this.leading;
		inputFormat.textTransform = this.textTransform;
		return inputFormat;
	}
}