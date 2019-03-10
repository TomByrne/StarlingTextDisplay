package workspace;

import starling.display.Sprite;
import starling.text.TextFormat;
import starling.text.TextField;
import starling.utils.HAlign;
import starling.utils.VAlign;

import model.Models;

class TextFieldLayer extends Sprite
{
    var format:TextFormat;
    var textField:TextField;

    public function new()
    {
        super();

        format = new TextFormat('mini', 16, 0x003333, HAlign.LEFT, VAlign.TOP);
        
        textField = new TextField(100, 100, '', format);
        textField.alpha = 0.6;
        addChild(textField);
        
        Models.layers.showTextField.bind(textField, 'visible');

        Models.text.text.bind(textField, 'text');
        
        Models.text.width.bind(textField, 'width');
        Models.text.height.bind(textField, 'height');
        
        Models.text.hAlign.bind(textField, 'hAlign');
        Models.text.vAlign.bind(textField, 'vAlign');
        Models.text.autoSize.bind(textField, 'autoSize');
        
        //Models.text.showTextBorder.bind(textField, 'showTextBorder');
        Models.text.showBoundsBorder.bind(textField, 'border');
        
        Models.text.size.bind(format, 'size');
        Models.text.size.add(updateFormat);
        
        Models.font.selectedFont.bind(format, 'font');
        Models.font.selectedFont.add(updateFormat);

        updateFormat();
    }

    function updateFormat()
    {
        trace('format: ' + format.font);
        textField.format = format;
    }
}