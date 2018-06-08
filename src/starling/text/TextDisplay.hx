package starling.text;

import openfl.geom.Rectangle;
import starling.display.DisplayObjectContainer;
import starling.display.Quad;
import starling.events.Event;
import starling.events.EventDispatcher;
import starling.text.TextFieldAutoSize;
import starling.text.control.ChangeControl;
import starling.text.control.focus.ClickFocus;
import starling.text.control.history.HistoryControl;
import starling.text.control.input.KeyboardInput;
import starling.text.control.input.KeyboardShortcuts;
import starling.text.control.input.MouseInput;
import starling.text.display.Caret;
import starling.text.display.ClipMask;
import starling.text.display.Highlight;
import starling.text.display.HitArea;
import starling.text.display.Links;
import starling.text.model.format.TextWrapping;
import starling.utils.SpecialChar;
//import starling.text.control.input.EventForwarder;
import starling.text.control.input.SoftKeyboardIO;
import starling.text.display.TargetBounds;
import starling.text.model.content.ContentModel;
import starling.text.model.format.FormatModel;

import starling.text.model.layout.Alignment;
import starling.text.model.layout.CharLayout;
import starling.text.model.selection.Selection;
import starling.text.model.format.InputFormat;
import starling.text.model.history.HistoryModel;
import starling.text.model.layout.Char;
import starling.text.util.CharRenderer;
import starling.text.util.FormatParser;

#if starling2

#else
	import starling.utils.HAlign;
	import starling.utils.VAlign;
#end

/**
 * ...
 * @author P.J.Shand
 */
class TextDisplay extends DisplayObjectContainer
{
	// DISPLAY
	@:allow(starling.text) var caret:Caret;
	@:allow(starling.text) var highlight:Highlight;
	@:allow(starling.text) var targetBounds:TargetBounds;
	@:allow(starling.text) var hitArea:HitArea;
	@:allow(starling.text) var clipMask:ClipMask;
	@:allow(starling.text) var links:Links;
	
	// MODEL
	@:allow(starling.text) var formatModel:FormatModel;
	@:allow(starling.text) var contentModel:ContentModel;
	@:allow(starling.text) var selection:Selection;
	@:allow(starling.text) var charLayout:CharLayout;
	@:allow(starling.text) var historyModel:HistoryModel;
	@:allow(starling.text) var alignment:Alignment;
	
	// UTILS
	@:allow(starling.text) var charRenderer:CharRenderer;
	
	// CONTROLLERS
	private var changeControl:ChangeControl;
	private var keyboardShortcuts:KeyboardShortcuts;
	private var keyboardInput:KeyboardInput;
	private var mouseInput:MouseInput;
	private var softKeyboardIO:SoftKeyboardIO;
	private var historyControl:HistoryControl;
	//private var eventForwarder:EventForwarder;
	private var clickFocus:ClickFocus;
	
	@:isVar public var color(get, set):Int = 0xFFFFFFFF;
	
	private var _value:String = "";
	@:allow(starling.text) var value(get, set):String;
	
	// Needs testing after refactoring
	//@:isVar public var text(default, set):String;
	
	@:isVar public var text(get, set):String;
	@:isVar public var htmlText(get, set):String;
	@:isVar public var autoSize(get, set):String;
	@:isVar private var hasFocus(default, set):Bool = false;
	@:isVar public var editable(default, set):Bool = false;
	
	@:isVar public var showBoundsBorder(default, set):Bool = false;
	@:isVar public var showTextBorder(default, set):Bool = false;
	@:isVar public var debug(default, set):Bool = false;
	@:isVar public var clipOverflow(default, set):Bool = false;
	@:isVar public var textWrapping(default, set):TextWrapping = TextWrapping.WORD;
	
	@:allow(starling.text) var targetWidth:Null<Float>;
	@:allow(starling.text) var targetHeight:Null<Float>;
	
	@:allow(starling.text) var _textBounds = new Rectangle();
	
	public var defaultFormat(get, set):InputFormat;
	
	public var textWidth(get, null):Float;
	public var textHeight(get, null):Float;
	public var textBounds(get, null):Rectangle;
	
	public var undoSteps(get, set):Int;
	public var clearUndoOnFocusLoss(get, set):Bool;
	
	public var highlightAlpha(get, set):Float;
	public var highlightColour(get, set):UInt;
	
	public var hAlign(get, set):String;
	public var vAlign(get, set):String;
	
	public var maxLines:Null<Int>;
	public var maxCharacters:Null<Int>;
	public var allowLineBreaks:Bool = true;
	
	public var ellipsis:String = "...";
	
	@:isVar public var numLines(get, null):Int;
	
	@:isVar public static var focus(get, set):TextDisplay = null;
	static var focusDispatcher = new EventDispatcher();
	
	public function new(width:Null<Float>=null, height:Null<Float>=null) 
	{
		super();
		
		targetWidth = width;
		targetHeight = height;
		
		if (targetHeight == null && targetWidth == null) autoSize = TextFieldAutoSize.BOTH_DIRECTIONS;
		else if (targetHeight == null) autoSize = TextFieldAutoSize.VERTICAL;
		else if (targetWidth == null) autoSize = TextFieldAutoSize.HORIZONTAL
		else autoSize = TextFieldAutoSize.NONE;
		
		createModels();
		createUtils();
		createDisplays(width, height);
		
		changeControl = new ChangeControl(this);
		createListeners();
		
		hasFocus = false;
		this.width = width;
		this.height = height;
		
		addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
		addEventListener(Event.REMOVED_FROM_STAGE, onRemovedToStage);
		
	}
	private function onAddedToStage(e:Event):Void 
	{
		TextDisplay.focusDispatcher.addEventListener(TextDisplayEvent.FOCUS, OnFocusChange);
	}
	private function onRemovedToStage(e:Event):Void 
	{
		TextDisplay.focusDispatcher.removeEventListener(TextDisplayEvent.FOCUS, OnFocusChange);
	}
	
	private function OnFocusChange(e:Event):Void 
	{
		if (TextDisplay.focus == this) hasFocus = true;
		else hasFocus = false;
	}
	
	function createModels() 
	{
		formatModel = new FormatModel(this);
		contentModel = new ContentModel(this);
		charLayout = new CharLayout(this);
		selection = new Selection(this);
		historyModel = new HistoryModel(this);
		alignment = new Alignment(this);
	}
	
	function createUtils() 
	{
		charRenderer = new CharRenderer(this);
	}
	
	function createDisplays(width:Float, height:Null<Float>) 
	{
		targetBounds = new TargetBounds(this, width, height);
		addChild(targetBounds);
		
		highlight = new Highlight(this);
		addChild(highlight);
		highlight.touchable = false;
		
		caret = new Caret(this);
		addChild(caret);
		
		clipMask = new ClipMask(this);
		addChild(clipMask);
		
		hitArea = new HitArea(this, width, height);
		addChild(hitArea);
		
		links = new Links(this);
		addChild(links);
	}
	
	function createControllers() 
	{
		if (softKeyboardIO == null) softKeyboardIO = new SoftKeyboardIO(this);
		if (keyboardShortcuts == null) keyboardShortcuts = new KeyboardShortcuts(this);
		if (keyboardInput == null) keyboardInput = new KeyboardInput(this);
		if (mouseInput == null) mouseInput = new MouseInput(this);
		if (clickFocus == null) clickFocus = new ClickFocus(this);
	}
	
	
	function createListeners() 
	{
		selection.addEventListener(Event.SELECT, OnSelect);
	}
	
	// TODO: remove listeners on dispose
	//function removeListeners() 
	//{
	//	selection.removeEventListener(Event.SELECT, OnSelect);
	//}
	
	private function OnSelect(e:Event):Void 
	{
		dispatchEvent(e);
	}
	
	public function setSelectionFormat(inputFormat:InputFormat):Void
	{
		var begin:Null<UInt> = selection.begin;
		var end:Null<UInt> = selection.end;
		if (begin != null && end != null) {
			setFormat(inputFormat, begin, end-1);
		}
		else {
			setFormat(inputFormat, selection.index, selection.index);
		}
	}
	
	public function setFormat(inputFormat:InputFormat, begin:Null<Int>=null, end:Null<Int>=null) 
	{
		if (begin == null && end == null) formatModel.setDefaults(inputFormat);
		contentModel.setFormat(inputFormat, begin, end);
		charLayout.process();
		dispatchEvent(new Event(Event.CHANGE));
	}
	public function getFormat(begin:Int, end:Int):InputFormat
	{
		return FormatParser.getFormat(this, contentModel.nodes, begin, end);
	}
	
	public function getSelectionFormat():InputFormat
	{
		var begin:Null<Int> = null;
		var end:Null<Int> = null;
		
		if (selection.begin == null && selection.end == null) {
			begin = selection.index;
			end = begin;
		}
		else {
			begin = selection.begin;
			end = selection.end;
		}
		
		if (begin == null && end == null) {
			return formatModel.defaultFormat;
		}
		return {
			if (value.length == 0) return formatModel.defaultFormat;
			else return FormatParser.getFormat(this, contentModel.nodes, begin, end);
		}
	}
	
	public function getSelectedText() 
	{
		if (selection.begin != null && selection.end != null) {
			return value.substring(selection.begin, selection.end);
		}
		else {
			return "";
		}
	}
	
	function get_text():String 
	{
		if (value == "") return "";
		return FormatParser.nodesToPlainText(contentModel.nodes);
	}
	
	function set_text(v:String):String 
	{
		if (this.text == v) return v;
		if (v == null) v = "";
		if (!allowLineBreaks) v = FormatParser.removeLineBreaks(v);
		
		if (maxCharacters != null) {
			if (v.length >= maxCharacters) v = v.substr(0, maxCharacters - ellipsis.length) + ellipsis;
		}
		contentModel.nodes = FormatParser.textAndFormatToNodes(v, defaultFormat);
		this.value = FormatParser.nodesToPlainText(contentModel.nodes);
		selection.index = this.value.length;
		dispatchEvent(new Event(Event.CHANGE));
		return text;
	}
	
	private function get_htmlText():String 
	{
		if (value == "") return "";
		return FormatParser.nodesToHtml(contentModel.nodes);
	}
	
	private function set_htmlText(v:String):String 
	{
		if (v == null) v = "";
		if (!allowLineBreaks) v = FormatParser.removeLineBreaks(v);
		else v = v.split("<BR/>").join("<br/>");
		contentModel.nodes = FormatParser.htmlToNodes(v);
		this.value = FormatParser.nodesToPlainText(contentModel.nodes);
		
		if (maxCharacters != null) {
			if (value.length >= maxCharacters) {
				FormatParser.removeAfterIndex(contentModel.nodes, maxCharacters - ellipsis.length);
				v = FormatParser.nodesToPlainText(contentModel.nodes) + ellipsis;
				contentModel.nodes = FormatParser.htmlToNodes(v);
				this.value = v;
			}
		}
		
		selection.index = this.value.length;
		dispatchEvent(new Event(Event.CHANGE));
		return htmlText;
	}
	
	private function get_value():String 
	{
		return _value;
	}
	
	private function set_value(v:String):String 
	{
		_value = v;
		selection.clear(true);
		createCharacters();
		if (_value.length > 0) selection.index = 0;
		else selection.clear();
		links.update();
		return _value;
	}
	
	function createCharacters() 
	{
		contentModel.update();
		charLayout.process();
	}
	
	function set_hasFocus(value:Null<Bool>):Null<Bool> 
	{
		if (hasFocus == value) return value;
		hasFocus = value;
		dispatchEvent(new Event(Event.FOCUS_CHANGE));
		UpdateActive();
		return hasFocus;
	}
	
	@:allow(starling.text)
	private function clearSelected(offset:Int=0) 
	{
		if (selection.begin != null) {
			remove(selection.begin + offset, selection.end + offset);
		}
		else {
			remove(selection.index - 1 + offset, selection.index + offset);	
		}
	}
	
	
	private function remove(start:Int, end:Int):Void
	{
		if (start < 0) start = 0;
		if (end < 0) end = 0;
		
		var split:Array<String> = _value.split("");
		split.splice(start, end - start);
		_value = split.join("");
		contentModel.remove(start, end);
		FormatParser.removeEmptyNodes(contentModel.nodes);
		FormatParser.mergeNodes(contentModel.nodes);
		charLayout.remove(start, end);
		dispatchEvent(new Event(Event.CHANGE));
	}
	
	
	
	private function replaceSelection(newChars:String):Void 
	{
		if (selection.begin != null) {
			checkKeyboardHistory();
			historyControl.setIgnoreChanges(true);
			clearSelected();
			historyControl.setIgnoreChanges(false);
		}
		
		if(selection.index == -1){
			add(newChars, 0);
			selection.index = newChars.length;
		}else{
			add(newChars, selection.index);
		}
	}
	
	private function add(letter:String, index:Int):Void
	{
		if (!allowLineBreaks && SpecialChar.isLineBreak(letter)) return;
		if (maxCharacters != null){
			if (_value.length >= maxCharacters) return;
		}
		
		var newValue:String = _value;
		if (index == _value.length){
			newValue += letter;
		}else if (index == 0){
			newValue = letter + _value;
		}else{
			newValue = _value.substr(0, index) + letter + _value.substr(index);
		}
		_value = newValue;
		
		contentModel.insert(letter, index);
		FormatParser.removeEmptyNodes(contentModel.nodes);
		FormatParser.mergeNodes(contentModel.nodes);
		charLayout.add(letter, index);
		dispatchEvent(new Event(Event.CHANGE));
	}
	
	private function set_showBoundsBorder(value:Bool):Bool	{ return hitArea.showBorder = value; }
	private function set_showTextBorder(value:Bool):Bool	{ return hitArea.showBorder = value; }
	private function set_debug(value:Bool):Bool
	{
		debug = value;
		this.showBoundsBorder = value;
		this.showTextBorder = value;
		return value;
	}
	private function set_clipOverflow(value:Bool):Bool
	{
		clipOverflow = value;
		this.clipMask.Update();
		return value;
	}
	private function set_textWrapping(value:TextWrapping):TextWrapping
	{
		textWrapping = value;
		this.charLayout.textWrapping = value;
		charLayout.process();
		return value;
	}
	
	
	private function get_vAlign():String					{ return alignment.vAlign; }
	private function set_vAlign(value:String):String		{ return alignment.vAlign = value; }
	private function get_hAlign():String					{ return alignment.hAlign; }
	private function set_hAlign(value:String):String		{ return alignment.hAlign = value; }
	
	private function get_highlightAlpha():Float				{ return highlight.highlightAlpha; }
	private function set_highlightAlpha(value:Float):Float	{ return highlight.highlightAlpha = value; }
	private function get_highlightColour():UInt				{ return highlight.highlightColour; }
	private function set_highlightColour(value:UInt):UInt	{ return highlight.highlightColour = value; }
	
	private function get_textHeight():Float 				{ return _textBounds.height; }
	private function get_textWidth():Float 					{ return _textBounds.width; }
	private function get_textBounds():Rectangle 			{ return _textBounds; }
	
	
	
	override function get_height():Float { return targetBounds.getBounds(parent).height; }
	override function set_height(value:Float):Float 
	{
		if (targetHeight == value) return value;
		targetHeight = value;
		//targetBounds.height = value; // This will change the scaleY of targetBounds, which should stay 1
		charLayout.process();
		dispatchEvent(new TextDisplayEvent(TextDisplayEvent.SIZE_CHANGE));
		return value;
	}
	
	override function get_width():Float { return targetBounds.getBounds(parent).width; }
	override function set_width(value:Float):Float 
	{
		if (targetWidth == value) return value;
		targetWidth = value;
		//targetBounds.width = value;
		charLayout.process();
		dispatchEvent(new TextDisplayEvent(TextDisplayEvent.SIZE_CHANGE));
		return value;
	}
	
	function set_editable(value:Bool):Bool 
	{
		if (editable == value) return value;
		editable = value;
		UpdateActive();
		return editable;
	}
	
	function UpdateActive() 
	{
		if (editable) {
			
			createControllers();
			
			//eventForwarder.active = hasFocus;
			keyboardInput.active = keyboardShortcuts.active = caret.active = hasFocus;
			mouseInput.active = true;
			highlight.visible = true;
			if (historyControl != null) historyModel.active = hasFocus;
			
		}
		else {
			//eventForwarder.active = false;
			if (keyboardInput != null) keyboardInput.active = false;
			if (keyboardShortcuts != null) keyboardShortcuts.active = false;
			if (mouseInput != null) mouseInput.active = false;
			caret.active = false;
			highlight.visible = false;
			if (historyControl != null) historyModel.active = false;
		}
	}
	
	function get_undoSteps():Int 
	{
		if (historyControl == null) return 0;
		return historyModel.undoSteps;
	}
	
	function set_undoSteps(value:Int):Int 
	{
		checkKeyboardHistory();
		return historyModel.undoSteps = value;
	}
	
	function get_clearUndoOnFocusLoss():Bool 
	{
		if (historyControl == null) return false;
		return historyModel.clearUndoOnFocusLoss;
	}
	
	function set_clearUndoOnFocusLoss(value:Bool):Bool 
	{
		checkKeyboardHistory();
		return historyModel.clearUndoOnFocusLoss = value;
	}
	
	function checkKeyboardHistory() 
	{
		if (historyControl == null){
			historyControl = new HistoryControl(this);
			historyModel.active = hasFocus && editable;
		}
	}
	
	function get_autoSize():String 
	{
		return autoSize;
	}
	
	function set_autoSize(value:String):String 
	{
		autoSize = value;
		if(charLayout != null) charLayout.process();
		return value;
	}
	
	function get_defaultFormat():InputFormat 
	{
		return formatModel.defaultFormat;
	}
	function set_defaultFormat(value:InputFormat):InputFormat 
	{
		if(value != null){
			formatModel.setDefaults(value);
			charLayout.process();
			dispatchEvent(new Event(Event.CHANGE));
		}
		return formatModel.defaultFormat;
	}
	
	
	
	override function dispose() 
	{
		TextDisplay.focusDispatcher.removeEventListener(TextDisplayEvent.FOCUS, OnFocusChange);
		super.dispose();
		charRenderer.dispose();
	}
	
	function get_numLines():Int 
	{
		return charLayout.lines.length;
	}
	
	static function get_focus():TextDisplay 
	{
		return focus;
	}
	
	static function set_focus(value:TextDisplay):TextDisplay 
	{
		focus = value;
		TextDisplay.focusDispatcher.dispatchEvent(new Event(TextDisplayEvent.FOCUS));
		return focus;
	}
	
	function get_color():Int 
	{
		return color;
	}
	
	function set_color(value:Int):Int 
	{
		charRenderer.setColor(value);
		return color = value;
	}
}