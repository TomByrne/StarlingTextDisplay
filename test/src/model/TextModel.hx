package model;

import starling.utils.HAlign;
import starling.utils.VAlign;
import starling.text.TextFieldAutoSize;

class TextModel
{
    public function new(){}

    public var text:Value<String> = new Value('Testing Text');
    
    public var autoSize:Value<String> = new Value(TextFieldAutoSize.NONE);
    
    public var hAlign:Value<String> = new Value(HAlign.LEFT);
    public var vAlign:Value<String> = new Value(VAlign.TOP);

    public var width:Value<Float> = new Value(300.0);
    public var height:Value<Float> = new Value(300.0);
}