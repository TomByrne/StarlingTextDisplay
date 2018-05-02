package starling.text.control.input;

import com.imagination.core.managers.touch.TouchManager;
import com.imagination.util.geom.Point;
import com.imagination.util.time.EnterFrame;
import openfl.Lib;
import openfl.Vector;
import openfl.events.MouseEvent;
import openfl.ui.Mouse;
import openfl.ui.MouseCursor;

import starling.core.Starling;
import starling.display.DisplayObject;
import starling.display.DisplayObjectContainer;
import starling.display.Quad;
import starling.events.Event;
import starling.events.Touch;
import starling.events.TouchEvent;
import starling.events.TouchPhase;
import starling.text.TextDisplay;
import starling.text.model.layout.Char;
import starling.text.model.layout.CharLayout;
import starling.text.model.selection.Selection;
import starling.text.model.layout.Word;

/**
 * ...
 * @author P.J.Shand
 */
class MouseInput
{
	static var inited:Bool;
	
	private var textDisplay:TextDisplay;
	private var selection:Selection;
	
	private var _active:Bool = true;
	public var active(get, set):Bool;
	var pressChar:Char;
	var moveChar:Char;
	
	private var lastPressTime:Float = 0;
	private var pressTime:Float;
	
	private static var SELECT_BY_CHAR:String = "char";
	private static var SELECT_BY_WORD:String = "word";
	
	private var selectType:String = SELECT_BY_CHAR;
	private var pressWord:Word;
	private var moveWord:Word;
	private var hovering:Bool;
	
	static private var pendingRemoveFocus:Void->Void;
	
	private static function OnMouseDown(e:MouseEvent):Void 
	{
		if (TextDisplay.focus != null) return;
		pendingRemoveFocus = RemoveFocus.bind(TextDisplay.focus);
		EnterFrame.delay(RemoveFocus.bind(TextDisplay.focus));
	}
	
	static private function RemoveFocus(wasFocus:TextDisplay) 
	{
		pendingRemoveFocus = null;
		if (TextDisplay.focus != wasFocus) return;
		TextDisplay.focus = null;
	}
	
	@:allow(starling.text)
	private function new(textDisplay:TextDisplay)
	{
		if (!inited){
			inited = true;
			Lib.current.stage.addEventListener(MouseEvent.MOUSE_DOWN, OnMouseDown);
		}
		
		this.textDisplay = textDisplay;
		this.selection = textDisplay.selection;
		textDisplay.addEventListener(Event.ADDED_TO_STAGE, OnAddToStage);
	}
	
	private function OnAddToStage(e:Event):Void 
	{
		textDisplay.removeEventListener(Event.ADDED_TO_STAGE, OnAddToStage);
		//moveUp(textDisplay.hitArea, textDisplay.hitArea.parent, 1);
	}
	
	/*function moveUp(child:DisplayObjectContainer, parent:DisplayObjectContainer, value:Float) 
	{
		if (parent.parent == null || value == 0) {
			parent.addChild(child);
		}
		else {
			moveUp(child, parent.parent, --value);
		}
	}*/
	
	function get_active():Bool 
	{
		return _active;
	}
	
	function set_active(value:Bool):Bool 
	{
		_active = value;
		if (_active) {
			textDisplay.hitArea.addEventListener(TouchEvent.TOUCH, OnTouch);
		}
		else {
			setHovering(false);
			textDisplay.hitArea.removeEventListener(TouchEvent.TOUCH, OnTouch);
		}
		return _active;
	}
	
	private function OnTouch(e:TouchEvent):Void 
	{
		setHovering(e.interactsWith(textDisplay.hitArea));
		
		//#if starling2
			//var beginTouches:Array<Touch> = e.getTouches(untyped e.target, TouchPhase.BEGAN);
			//var moveTouches:Array<Touch> = e.getTouches(untyped e.target, TouchPhase.MOVED);
		//#else
			var beginTouches:Vector<Touch> = e.getTouches(untyped e.target, TouchPhase.BEGAN);
			var moveTouches:Vector<Touch> = e.getTouches(untyped e.target, TouchPhase.MOVED);
		//#end
		if (beginTouches.length > 0) {
			OnBegin(beginTouches[0]);
		}
		if (moveTouches.length > 0) {
			OnMove(moveTouches[0]);
		}
	}
	
	function setHovering(hovering:Bool) 
	{
		if (this.hovering == hovering) return;
		this.hovering = hovering;
		Mouse.cursor = hovering ? MouseCursor.IBEAM : MouseCursor.AUTO;
	}
	
	private function OnBegin(touch:Touch) 
	{
		if(pendingRemoveFocus != null) EnterFrame.remove(pendingRemoveFocus);
		
		TextDisplay.focus = textDisplay;
		lastPressTime = pressTime;
		pressTime = Date.now().getTime();
		if (Math.abs(lastPressTime - pressTime) < 500) selectType = MouseInput.SELECT_BY_WORD;
		else selectType = MouseInput.SELECT_BY_CHAR;
		
		var pos:Point = textDisplay.globalToLocal(new Point(touch.globalX, touch.globalY));
		if (selectType == MouseInput.SELECT_BY_WORD) {
			pressWord = textDisplay.charLayout.getWordByPosition(pos.x, pos.y);
			if (pressWord != null) {
				selection.set(pressWord.begin.index, pressWord.end.index + 1, pressWord.end.index + 1);
				return;
			}
		}
		pressChar = textDisplay.charLayout.getCharByPosition(pos.x, pos.y);
		selection.index = pressChar.index;
	}
	
	private function OnMove(touch:Touch) 
	{
		var pos:Point = textDisplay.globalToLocal(new Point(touch.globalX, touch.globalY));
		
		if (selectType == MouseInput.SELECT_BY_WORD) {
			moveWord = textDisplay.charLayout.getWordByPosition(pos.x, pos.y);
			if (moveWord != null ){
				var index:Int = moveWord.index;
				if (pressWord == null){
					selection.set(moveWord.begin.index, moveWord.end.index + 1, moveWord.end.index + 1);
					pressWord = moveWord;
				}
				else if (pressWord.index < moveWord.index) {
					selection.set(pressWord.begin.index, moveWord.end.index + 1, moveWord.end.index + 1);
				}
				else if (pressWord.index > moveWord.index) {
					selection.set(moveWord.begin.index, pressWord.end.index + 1, moveWord.begin.index);
				}
				else {
					selection.set(moveWord.begin.index, moveWord.end.index + 1, moveWord.end.index + 1);
				}
				return;
			}
		}
		moveChar = textDisplay.charLayout.getCharByPosition(pos.x, pos.y);
		var index:Int = moveChar.index;
		//if (pressChar != null) trace("pressChar: " + pressChar.index + " " + moveChar.index);
		//else trace("pressChar: " + pressChar + " " + moveChar.index);
		
		if (pressChar == null){
			selection.index = moveChar.index;
			pressChar = moveChar;
		}
		else if (pressChar.index < moveChar.index) {
			selection.set(pressChar.index, moveChar.index, index);
		}
		else if (pressChar.index > moveChar.index) {
			selection.set(moveChar.index, pressChar.index, index);
		}
		else {
			selection.index = moveChar.index;
		}
	}
	
}
