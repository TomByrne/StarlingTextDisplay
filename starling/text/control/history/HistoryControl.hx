package starling.text.control.history;

import com.imagination.util.ds.LinkedList;
import com.imagination.util.ds.LinkedList.LinkedListItem;
import openfl.ui.Keyboard;
import starling.events.Event;
import starling.text.model.layout.CharLayout;
import starling.text.model.selection.Selection;
import openfl.desktop.Clipboard;
import openfl.desktop.ClipboardFormats;
import starling.events.KeyboardEvent;
import starling.core.Starling;
import starling.text.TextDisplay;
import starling.text.model.history.HistoryModel;
import starling.text.model.history.HistoryStep;

/**
 * ...
 * @author Thomas Byrne
 */
class HistoryControl
{
	private var historyModel:HistoryModel;
	private var selection:Selection;
	private var textDisplay:TextDisplay;
	
	@:allow(starling.text)
	private function new(textDisplay:TextDisplay)
	{
		this.textDisplay = textDisplay;
		this.historyModel = textDisplay.historyModel;
		this.selection = textDisplay.selection;
		
		historyModel.onActiveChange.add(OnActiveChange);
		
		textDisplay.charLayout.addEventListener(Event.CHANGE, onTextChange);
		selection.addEventListener(Event.SELECT, onSelectionChange);
	}
	
	function OnActiveChange() 
	{
		if (historyModel.active) {
			textDisplay.addEventListener(KeyboardEvent.KEY_DOWN, OnKeyDown);
			storeStep();
		}
		else {
			textDisplay.removeEventListener(KeyboardEvent.KEY_DOWN, OnKeyDown);
			if (historyModel.clearUndoOnFocusLoss){
				historyModel.clearHistory();
			}
		}
	}
	
	private function onSelectionChange(e:Event):Void 
	{
		if (historyModel.ignoreChanges || !historyModel.active) return;
		
		var currStep:HistoryStep = (historyModel.currStepIndex ==-1 ? null : historyModel.history[historyModel.currStepIndex]);
		if (currStep!=null){
			currStep.selectionIndex = selection.index;
			currStep.selectionBegin = selection.begin;
			currStep.selectionEnd = selection.end;
		}
	}
	
	private function onTextChange(e:Event):Void 
	{
		if (historyModel.ignoreChanges || !historyModel.active) return;
		
		storeStep();
	}
	
	function storeStep() 
	{
		var html = this.textDisplay.htmlText;
		var currStep:HistoryStep = (historyModel.currStepIndex ==-1 ? null : historyModel.history[historyModel.currStepIndex]);
		if (currStep!=null && currStep.htmlText == html){
			currStep.selectionIndex = selection.index;
			currStep.selectionBegin = selection.begin;
			currStep.selectionEnd = selection.end;
			return;
		}
		
		var step:HistoryStep = (HistoryModel.stepPool.length > 0 ? HistoryModel.stepPool.pop() : new HistoryStep());
		step.htmlText = this.textDisplay.htmlText;
		step.selectionIndex = selection.index;
		step.selectionBegin = selection.begin;
		step.selectionEnd = selection.end;
		
		if (historyModel.currStepIndex !=-1 && historyModel.currStepIndex != historyModel.history.length - 1){
			historyModel.recycleSteps(historyModel.history.splice(historyModel.currStepIndex+1, historyModel.history.length - historyModel.currStepIndex - 1));
		}
		if (historyModel.history.length > historyModel.undoSteps-1){
			historyModel.recycleSteps(historyModel.history.splice(0, historyModel.history.length - (historyModel.undoSteps-1)));
		}
		historyModel.history.push(step);
		historyModel.currStepIndex = historyModel.history.length - 1;
		
	}
	
	private function OnKeyDown(e:KeyboardEvent):Void 
	{
		if (e.isDefaultPrevented()) return;
		
		if (e.keyCode == Keyboard.Z && e.ctrlKey && !e.shiftKey && !e.altKey) historyModel.undo();
		else if (e.keyCode == Keyboard.Y && e.ctrlKey && !e.shiftKey && !e.altKey) historyModel.redo(); // Normal Redo (CTRL + Y)
		else if (e.keyCode == Keyboard.Z && e.ctrlKey && e.shiftKey && !e.altKey) historyModel.redo(); // Rarer Redo (CTRL + SHIFT + Z)
	}
}