package ui.custom;

import haxe.ui.containers.Box;
import haxe.ui.events.MouseEvent;
import haxe.ui.events.UIEvent;
import model.Value;

@:build(haxe.ui.macros.ComponentMacros.build("layouts/custom/model-slider.xml"))
class ModelSlider extends Box {
    @:bind(valueSlider.min)
    public var min:Float;
    
    @:bind(valueSlider.max)
    public var max:Float;
    
    @:bind(valueSlider.pos)
    public var pos:Float;
    
    @:bind(valueSlider.precision)
    public var precision:Int;

    public var percent:Bool = false;
    
    public function new() {
        super();
    }
    
    @:bind(textValueField, UIEvent.CHANGE)
    private function onTextChanged(e) {
        if (_model == null) {
            return;
        }
        
        _model.data = Std.parseFloat(textValueField.text) / (percent ? 100 : 1);
    }

    public var label(get, set):String;
    private function get_label():String {
        if (button.hidden == false) {
            return button.text;
        }
        return labelText.text;
    }
    private function set_label(value:String):String {
        button.text = value;
        labelText.text = value;
        return value;
    }
    
    public var modelOnClick:Dynamic;
    @:bind(button, MouseEvent.CLICK)
    private function onButton(e) {
        if (modelOnClick != null) {
            model.data = modelOnClick;
        }
        dispatch(new MouseEvent(MouseEvent.CLICK));
    }
    
    @:bind(valueSlider, UIEvent.CHANGE)
    private function onSliderChanged(e) {
        if (_model == null) {
            return;
        }
        
        var newValue:Float = valueSlider.pos;
        if (newValue == null || Math.isNaN(newValue)) {
            newValue = valueSlider.min;
        }

        if (percent) {
            newValue /= 100;
        }
        _model.data = newValue;
    }

    private var _model:Value<Dynamic> = null;
    public var model(get, set):Value<Dynamic>; // would be nice to somehow be able to set this from xml
    private function get_model():Value<Dynamic> {
        return _model;
    }
    private function set_model(value:Value<Dynamic>):Value<Dynamic> {
        _model = value;
        _model.add(onModelChanged);
        onModelChanged();
        return value;
    }
    
    public var mode(get, set):String;
    private function get_mode():String {
        if (button.hidden == false) {
            return "button";
        }
        return null;
    }
    private function set_mode(value:String):String {
        if (value == "button") {
            button.show();
            labelText.hide();
        } else {
            button.hide();
            labelText.show();
        }
        return value;
    }
    
    private function onModelChanged() {
        var value = model.data;
        if (value == null || Math.isNaN(value)) {
            value = valueSlider.min;
        }

        if (percent) {
            value *= 100;
            textValueField.text = Std.string(value) + '%';
        } else {
            textValueField.text = Std.string(value);
        }
        valueSlider.pos = value;
    }
}