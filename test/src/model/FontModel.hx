package model;

import signal.Signal1;

class FontModel
{
    public var addFont:Signal1<FontInfo> = new Signal1();

    public var fonts:Value<Array<FontInfo>> = new Value([]);
    public var selectedFont:Value<String> = new Value();

    public var renderScaling:Value<Float> = new Value(1.0);
    public var renderSuperSampling:Value<Int> = new Value(1);

    public function new(){}
}

typedef FontInfo =
{
    ?label:String,
    ?regName:String,
    ?filename:String,
    ?type:FontType,
    ?fontData:String,
    ?size:Int,
    ?range:Array<Int>,
}

@:enum abstract FontType(String)
{
    var SVG = 'svg';
    var BUILT_IN = 'builtIn';
}