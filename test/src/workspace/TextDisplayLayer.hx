package workspace;

import starling.display.Sprite;
import starling.text.TextDisplay;
import starling.text.model.format.InputFormat;

import model.Models;

class TextDisplayLayer extends Sprite
{
    var format:InputFormat;
    var textDisplay:TextDisplay;

    public function new()
    {
        super();

        format = new InputFormat();
        format.color = 0x000000;
        
        textDisplay = new TextDisplay();
        addChild(textDisplay);

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
    }

    function updateFormat()
    {
        textDisplay.setFormat(format);
    }
}