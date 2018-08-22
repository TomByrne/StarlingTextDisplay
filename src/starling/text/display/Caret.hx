package starling.text.display;

import openfl.events.TimerEvent;
import openfl.utils.Timer;

import com.imagination.util.geom.Matrix;

import starling.text.model.format.InputFormat;
import starling.text.model.layout.Char;
import starling.text.model.layout.CharLayout;
import starling.text.model.selection.Selection;
import starling.display.DisplayObjectContainer;
import starling.display.Quad;
import starling.events.Event;

/**
 * ...
 * @author P.J.Shand
 */
class Caret extends DisplayObjectContainer
{
	private static var DUMMY_MAT:Matrix = new Matrix();
	
	private var _active:Null<Bool> = null;
	public var active(get, set):Null<Bool>;
	
	public var format:InputFormat;
	public var font:BitmapFont;
	
	@:isVar private var selectedChar(get, set):Char;
	
	var timer:Timer;
	var quad:Quad;
	var textDisplay:TextDisplay;
	
	@:allow(starling.text)
	private function new(textDisplay:TextDisplay) 
	{
		super();
		
		this.textDisplay = textDisplay;
		this.format = textDisplay.formatModel.defaultFormat.clone();
		this.touchable = false;
		
		quad = new Quad(2, 40, 0xFFFFFF);
		quad.pivotX = 1;
		quad.visible = false;
		addChild(quad);
		
		textDisplay.selection.addEventListener(Event.SELECT, OnSelectionChange);
		textDisplay.charLayout.addEventListener(Event.CHANGE, UpdateVis);
		
		timer = new Timer(500, 0);
		timer.addEventListener(TimerEvent.TIMER, OnTick);
		
		OnSelectionChange(null);
	}
	
	private function OnTick(e:TimerEvent):Void 
	{
		if (quad.visible) quad.visible = false;
		else quad.visible = true;
		
		this.getTransformationMatrix(stage, DUMMY_MAT);
		this.scaleX *= 1 / DUMMY_MAT.a;
	}
	
	private function OnSelectionChange(e:Event):Void 
	{
		if (textDisplay.selection.index != null && textDisplay.selection.index != -1 && textDisplay.charLayout.characters.length != 0) {
			var selectedIndex:Int = textDisplay.selection.index - 1;
			if (selectedIndex < 0) selectedIndex = 0;
			selectedChar = textDisplay.charLayout.characters[selectedIndex];
		}
		UpdateVis();
	}
	
	function UpdateVis() 
	{
		if(_active){
			if(textDisplay.selection.index != -1){
				setIndex(textDisplay.selection.index);
			}
			else {
				setIndex(0);
			}
		}
		checkVisibility();
	}
	
	function checkVisibility() 
	{
		if (selectedChar == null) return;
		if (textDisplay.maxLines != null && selectedChar.line.index >= textDisplay.maxLines) {
			timer.stop();
			visible = false;
		}
		else if (_active && textDisplay.selection.index != -1 /*&& !selectedChar.line.outsizeBounds*/) {
			timer.start();
			visible = true;
		}
		else {
			timer.stop();
			visible = false;
		}
	}
	
	function setIndex(index:Int) 
	{
		selectedChar = textDisplay.charLayout.getCharOrEnd(index);
		if (selectedChar == null) return;
		
		this.x = selectedChar.x;
		
		if (selectedChar.line == null){
			this.y = 0;
		}else {
			this.y = selectedChar.line.y;
			this.height = selectedChar.line.height;
		}
	}
	
	function get_active():Null<Bool> 
	{
		return _active;
	}
	
	function set_active(value:Null<Bool>):Null<Bool> 
	{
		if (_active == value) return value;
		_active = value;
		
		UpdateVis();
		
		return _active;
	}
	
	function get_selectedChar():Char 
	{
		return selectedChar;
	}
	
	function set_selectedChar(value:Char):Char 
	{
		selectedChar = value;
		
		if (selectedChar == null) return selectedChar;
		
		this.format = selectedChar.format.clone();
		this.font = selectedChar.font;
		quad.color = format.color;
		return selectedChar;
	}
}