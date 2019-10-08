package workspace;

import starling.display.Sprite;
import starling.text.TextDisplay;
import starling.text.model.format.InputFormat;
import starling.events.*;

import model.Models;

class TextDisplayLayer extends Sprite
{
    var format:InputFormat;
    var textDisplay:TextDisplay;
    var ignoreChanges:Bool;

    public function new()
    {
        super();

        format = new InputFormat();
        format.color = 0x000000;
        
        textDisplay = new TextDisplay();
        textDisplay.addEventListener(Event.CHANGE, onTextDisplayChange);
        textDisplay.addEventListener(TextDisplayEvent.FOCUS_CHANGE, onFocusChange);
        addChild(textDisplay);

        Models.text.text.add(onTextModelChange);
        onTextModelChange();

        Models.text.text.bind(textDisplay, 'text');
        
        Models.text.width.bind(textDisplay, 'width');
        Models.text.height.bind(textDisplay, 'height');
        
        Models.text.hAlign.bind(textDisplay, 'hAlign');
        Models.text.vAlign.bind(textDisplay, 'vAlign');
        Models.text.autoSize.bind(textDisplay, 'autoSize');
        
        Models.text.showTextBorder.bind(textDisplay, 'showTextBorder');
        Models.text.showBoundsBorder.bind(textDisplay, 'showBoundsBorder');
        Models.text.clipOverflow.bind(textDisplay, 'clipOverflow');
        Models.text.editable.bind(textDisplay, 'editable');
        Models.text.allowLineBreaks.bind(textDisplay, 'allowLineBreaks');
        Models.text.smoothing.bind(textDisplay, 'textureSmoothing');
        Models.text.snapCharsTo.bind(textDisplay, 'snapCharsTo');
        
        Models.text.size.bind(format, 'size');
        Models.text.size.add(updateFormat);
        
        Models.font.selectedFont.bind(format, 'face');
        Models.font.selectedFont.add(updateFormat);
        
        Models.text.kerning.bind(format, 'kerning');
        Models.text.kerning.add(updateFormat);

        Models.text.leading.bind(format, 'leading');
        Models.text.leading.add(updateFormat);

        updateFormat();

        onFocusChange(null); // reset model
    }

    function onFocusChange(e:Event)
    {
        Models.text.hasFocus.data = (TextDisplay.focus == textDisplay);
    }

    function onTextDisplayChange(e:Event)
    {
        if(ignoreChanges) return;
        ignoreChanges = true;
        Models.text.text.data = textDisplay.text;
        ignoreChanges = false;
    }

    function onTextModelChange()
    {
        if(ignoreChanges) return;
        ignoreChanges = true;
        textDisplay.text = Models.text.text.data;
        ignoreChanges = false;
    }

    function updateFormat()
    {
        textDisplay.setFormat(format);
    }
}