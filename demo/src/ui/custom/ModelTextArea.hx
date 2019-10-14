package ui.custom;

import haxe.ui.components.TextArea;
import haxe.ui.events.UIEvent;
import model.Value;

class ModelTextArea extends TextArea {
    public function new() {
        super();
    }
    
    private var _model:Value<Dynamic> = null;
    public var model(get, set):Value<Dynamic>; // would be nice to somehow be able to set this from xml
    private function get_model():Value<Dynamic> {
        return _model;
    }
    private function set_model(value:Value<Dynamic>):Value<Dynamic> {
        _model = value;
        _model.bind(this, "text");
        return value;
    }
    
    @:bind(this, UIEvent.CHANGE)
    private function onTextChanged(e) {
        if (_model == null) {
            return;
        }
        
        _model.data = this.text; 
    }
}
