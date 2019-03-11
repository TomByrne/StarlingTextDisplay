package model;

import starling.utils.HAlign;
import starling.utils.VAlign;
import starling.text.TextFieldAutoSize;

class TextModel
{
    public function new(){}

    public var text:Value<String> = new Value('Testing Text');
    
    public var autoSize:Value<String> = new Value(TextFieldAutoSize.NONE);
    
    public var size:Value<Float> = new Value(20.0);
    
    public var hAlign:Value<String> = new Value(HAlign.LEFT);
    public var vAlign:Value<String> = new Value(VAlign.TOP);
    
    public var smoothing:Value<String> = new Value(null);

    public var width:Value<Float> = new Value(300.0);
    public var height:Value<Float> = new Value(300.0);

    public var snapCharsTo:Value<Float> = new Value(0.0);
    
    public var showTextBorder:Value<Bool> = new Value(true);
    public var showBoundsBorder:Value<Bool> = new Value(true);
    public var clipOverflow:Value<Bool> = new Value(false);
}