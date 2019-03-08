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
        textDisplay.text = 'Testing';
        textDisplay.showBoundsBorder = true;
        textDisplay.showTextBorder = true;
        addChild(textDisplay);

        updateFormat();

        Models.text.text.bind(textDisplay, 'text');
        
        Models.text.width.bind(textDisplay, 'width');
        Models.text.height.bind(textDisplay, 'height');
        
        Models.text.hAlign.bind(textDisplay, 'hAlign');
        Models.text.vAlign.bind(textDisplay, 'vAlign');
        Models.text.autoSize.bind(textDisplay, 'autoSize');

        //Models.text.hAlign.add(updateFormat);
    }

    function updateFormat()
    {
        textDisplay.setFormat(format);
    }
}