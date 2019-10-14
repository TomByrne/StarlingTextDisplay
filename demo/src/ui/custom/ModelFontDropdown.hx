package ui.custom;

import haxe.ui.containers.Box;
import model.Value;

@:build(haxe.ui.macros.ComponentMacros.build("layouts/custom/model-font-dropdown.xml"))
class ModelFontDropdown extends Box {
    public function new() {
        super();
    }
    
    private var _model:Value<Dynamic> = null;
    public var model(get, set):Value<Dynamic>; // would be nice to somehow be able to set this from xml
    private function get_model():Value<Dynamic> {
        return _model;
    }
    @:access(ui.custom.ModelDropdown)
    private function set_model(value:Value<Dynamic>):Value<Dynamic> {
        fontDropdown.model = value;
        new FontSelect(fontDropdown, addFont, fontDropdown.onModelChanged);
        return value;
    }
    
    private override function set_text(value:String):String {
        super.set_text(value);
        fontDropdown.text = value;
        return value;
    }
}