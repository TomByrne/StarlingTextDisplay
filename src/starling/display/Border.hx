package starling.display;
import starling.core.RenderSupport;

/**
 * ...
 * @author Thomas Byrne
 */
class Border extends QuadBatch 
{
	public var position(default, set):BorderPosition;
	public var thickness(default, set):Float;
	public var color(default, set):UInt;
	
	
	
	var top:Quad;
	var bottom:Quad;
	var left:Quad;
	var right:Quad;
	var invalid:Bool = true;
	
	var _width:Float;
	var _height:Float;
	var _color:UInt;

	public function new(width:Float = 100, height:Float = 100, color:UInt = 0xffffff, thickness:Float = 1, position:BorderPosition = BorderPosition.INSIDE) 
	{
		super();
		
		batchable = true;
		touchable = false;
		
		top = new Quad(100, 100, color);
		bottom = new Quad(100, 100, color);
		left = new Quad(100, 100, color);
		right = new Quad(100, 100, color);
		
		_width = width;
		_height = height;
		_color = color;
		this.thickness = thickness;
		this.position = position;
	}
	
	override public function render(support:RenderSupport, parentAlpha:Float):Void 
	{
		if (invalid){
			reset();
			
			var l:Float = 0;
			var t:Float = 0;
			var r:Float = _width;
			var b:Float = _height;
			
			switch(position){
				case OUTSIDE:
					l -= thickness;
					t -= thickness;
					r += thickness;
					b += thickness;
				case CENTER:
					l -= thickness / 2;
					t -= thickness / 2;
					r += thickness / 2;
					b += thickness / 2;
				case INSIDE:
					// ignore
			}
			
			top.x = l;
			top.y = t;
			top.width = r - l;
			top.height = thickness;
			addQuad(top);
			
			left.x = l;
			left.y = t + thickness;
			left.width = thickness;
			left.height = b - t - thickness * 2;
			addQuad(left);
			
			bottom.x = l;
			bottom.y = b - thickness;
			bottom.width = r - l;
			bottom.height = thickness;
			addQuad(bottom);
			
			right.x = r - thickness;
			right.y = t + thickness;
			right.width = thickness;
			right.height = b - t - thickness * 2;
			addQuad(right);
			
			invalid = false;
		}
		
		super.render(support, parentAlpha);
	}
	
	override function get_width():Float 
	{
		return _width;
	}
	override function set_width(value:Float):Float 
	{
		if (_width == value) return value;
		_width = value;
		invalid = true;
		return value;
	}
	
	override function get_height():Float 
	{
		return _height;
	}
	override function set_height(value:Float):Float 
	{
		if (_height == value) return value;
		_height = value;
		invalid = true;
		return value;
	}
	
	function set_position(value:BorderPosition):BorderPosition 
	{
		if (position == value) return value;
		position = value;
		invalid = true;
		return value;
	}
	function set_thickness(value:Float):Float 
	{
		if (thickness == value) return value;
		thickness = value;
		invalid = true;
		return value;
	}
	function set_color(value:UInt):UInt 
	{
		if (color == value) return value;
		color = value;
		invalid = true;
		return value;
	}
}


@:enum abstract BorderPosition(String){
	var INSIDE = "inside";
	var OUTSIDE = "outside";
	var CENTER = "center";
}