package starling.display;

import openfl.geom.Rectangle;

import starling.display.Image;
import starling.display.Sprite;
import starling.textures.Texture;

class Scale9Image extends Sprite
{
	private var _tl:Image;
	private var _tc:Image;
	private var _tr:Image;
	private var _cl:Image;
	private var _cc:Image;
	private var _cr:Image;
	private var _bl:Image;
	private var _bc:Image;
	private var _br:Image;
	
	private var _grid:Rectangle;
	private var _tW:Float;
	private var _tH:Float;
	
	
	private var _width:Float;
	private var _height:Float;
	private var _color:UInt;
	public var color(get, set):UInt;
	
	public var cornerScale(default, set):Float = 1.0;
	public function set_cornerScale(value:Float):Float
	{
		if(cornerScale != value){
			cornerScale = value;
			apply9Scale(_width, _height);
		}
		return value;
	}
	
	public var scaleIfSmaller(default, set):Bool;
	public function set_scaleIfSmaller(value:Bool):Bool
	{
		if(scaleIfSmaller != value){
			scaleIfSmaller = value;
			apply9Scale(_width, _height);
		}
		return value;
	}

	override function get_height():Float
	{
		return _height;
	}
	
	override function set_height(value:Float):Float
	{
		if (_height != value)
		{
			_height = value;
			apply9Scale(_width, _height);
		}
		return _height;
	}
	
	override function get_width():Float
	{
		return _width;
	}
	
	override function set_width(value:Float):Float
	{
		if (_width != value)
		{
			_width = value;
			apply9Scale(_width, _height);
		}
		return _width;
	}
	
	public function get_color( ):UInt
	{
		return _color;
	}
	
	public function set_color( value:UInt ):UInt
	{
		_color = value;
		
		_tl.color = value;
		_tc.color = value;
		_tr.color = value;
		_cl.color = value;
		_cc.color = value;
		_cr.color = value;
		_bl.color = value;
		_bc.color = value;
		_br.color = value;
		return value;
	}
	
	public function new(texture:Texture, centerRect:Rectangle):Void
	{
		super();
		_tW = texture.width;
		_tH = texture.height;
		_grid = centerRect;
		
		_width = _tW;
		_height = _tH;
		
		_tl = new Image(Texture.fromTexture(texture, new Rectangle(0, 0, _grid.x, _grid.y)));
		
		_tc = new Image(Texture.fromTexture(texture, new Rectangle(_grid.x,0,_grid.width,_grid.y)));
		
		_tr = new Image(Texture.fromTexture(texture, new Rectangle(_grid.x + _grid.width,0,texture.width - (_grid.x + _grid.width), _grid.y)));
		
		_cl = new Image(Texture.fromTexture(texture, new Rectangle(0,_grid.y,_grid.x,_grid.height)));
		
		_cc = new Image(Texture.fromTexture(texture, new Rectangle(_grid.x,_grid.y,_grid.width,_grid.height)));
		
		_cr = new Image(Texture.fromTexture(texture, new Rectangle(_grid.x + _grid.width,_grid.y,texture.width - (_grid.x + _grid.width),_grid.height)));
		
		_bl = new Image(Texture.fromTexture(texture, new Rectangle(0,_grid.y + _grid.height,_grid.x,texture.height -(_grid.y + _grid.height))));
		
		_bc = new Image(Texture.fromTexture(texture, new Rectangle(_grid.x,_grid.y + _grid.height,_grid.width,texture.height -(_grid.y + _grid.height))));
		
		_br = new Image(Texture.fromTexture(texture, new Rectangle(_grid.x + _grid.width,_grid.y + _grid.height,texture.width -(_grid.x + _grid.width),texture.height -(_grid.y + _grid.height))));

		
		addChild(_tl);
		addChild(_tc);
		addChild(_tr);
		
		addChild(_cl);
		addChild(_cc);
		addChild(_cr);
		
		addChild(_bl);
		addChild(_bc);
		addChild(_br);
		
		apply9Scale(_tW, _tH);
	}
	
	private function apply9Scale(x:Float, y:Float ):Void
	{	
		var width:Float = x/scaleX;
		var height:Float = y/scaleY;

		var textureWidth = _tW;
		var textureHeight = _tH;
		var gridX = _grid.x * cornerScale;
		var gridY = _grid.y * cornerScale;
		var gridW = _grid.width + (_grid.x - gridX) * 2;
		var gridH = _grid.height + (_grid.y - gridY) * 2;
		
		_tc.x = _cc.x = _bc.x = gridX;
		_cl.y = _cc.y = _cr.y = gridY;
		
		if(width < _tW-gridW)
		{
			_tc.visible = false;
			_bc.visible = false;
			
			if(!scaleIfSmaller)
			{
				var lw:Float = gridX;
				
				_tl.width = lw;
				_cl.width = lw;
				_bl.width = lw;
				
				_tr.x = lw;
				_cr.x = lw;
				_br.x = lw;
				
				var rw:Float = (_tW - gridX - gridW);
				_tr.width = rw;
				_cr.width = rw;
				_br.width = rw;
			}
			else
			{
				var pct:Float = width / (_tW -gridW);
				var lw:Float = gridX * pct;
				_tl.width = lw;
				_cl.width = lw;
				_bl.width = lw;

				var rw:Float = (_tW - gridX - gridW) * pct;
				_tr.width = rw;
				_cr.width = rw;
				_br.width = rw;
				
				var rx:Float = width - rw;
				_tr.x = rx;
				_cr.x = rx;
				_br.x = rx;
				
			}
		}
		else
		{
			_tc.visible = true;
			_bc.visible = true;
							
			var lw:Float = gridX;
			_tl.width = lw;
			_cl.width = lw;
			_bl.width = lw;
			
			var rw:Float = (_tW - gridX - gridW);
			_tr.width = rw;
			_cr.width = rw;
			_br.width = rw;
			
			var rx:Float = width - rw;
			_tr.x = rx;
			_cr.x = rx;
			_br.x = rx;
			
			var cw:Float = rx - gridX;
			_tc.width = cw;
			_cc.width = cw;
			_bc.width = cw;
		}
		
		if(height < _tH-gridH)
		{
			_cl.visible = false;
			_cr.visible = false;
			
			if(!scaleIfSmaller)
			{
				var tw:Float = gridY;
				_tl.height = tw;
				_tc.height = tw;
				_tr.height = tw;
			
				_br.y = tw;
				_bc.y = tw;
				_bl.y = tw;

				var bh:Float = (_tH - gridY - gridH);
				_br.height = bh;
				_bc.height = bh;
				_bl.height = bh;
			}
			else
			{
				var pct:Float = height / (_tH -gridH);
				
				var tw:Float = gridY * pct;
				_tl.height = tw;
				_tc.height = tw;
				_tr.height = tw;
				
				var bh:Float = (_tH - gridY - gridH) * pct;
				_br.height = bh;
				_bc.height = bh;
				_bl.height = bh;
				
				var bx:Float = height - bh;
				_br.y = bx;
				_bc.y = bx;
				_bl.y = bx;
				
			}
		}
		else
		{
			_cl.visible = true;
			_cr.visible = true;
			
			_tl.height = gridY;
			_tc.height = gridY;
			_tr.height = gridY;
			
			var bh:Float = (_tH - gridY - gridH);
			_bl.height = bh;
			_bc.height = bh;
			_br.height = bh;
			
			var by:Float = height - bh;
			_bl.y =	by;
			_bc.y =	by;
			_br.y =	by;

			var ch:Float = by - gridY;
			_cl.height = ch;
			_cc.height = ch;
			_cr.height = ch;				
		}
		
		_cc.visible = _cl.visible && _tc.visible;
	}
	
	override public function dispose():Void
	{
		_tl.texture.dispose();
		_tl.removeFromParent(true);
		_tc.texture.dispose();
		_tc.removeFromParent(true);
		_tr.texture.dispose();
		_tr.removeFromParent(true);
		_cl.texture.dispose();
		_cl.removeFromParent(true);
		_cc.texture.dispose();
		_cc.removeFromParent(true);
		_cr.texture.dispose();
		_cr.removeFromParent(true);
		_bl.texture.dispose();
		_bl.removeFromParent(true);
		_bc.texture.dispose();
		_bc.removeFromParent(true);
		_br.texture.dispose();
		_br.removeFromParent(true);
		
		super.dispose();
	}
}
