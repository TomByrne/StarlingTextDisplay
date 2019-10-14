package ui.custom;

import haxe.ui.components.DropDown;
import haxe.ui.data.ArrayDataSource;
import haxe.ui.events.UIEvent;
import model.Value;

class ModelDropdown extends DropDown {
    public function new() {
        super();
    }
    
    @:bind(this, UIEvent.CHANGE)
    private function onDropdownChanged(e) {
        if (_model == null) {
            return;
        }
        var item:DropDownItem = this.selectedItem;
        _model.data = item.childId;
    }
    
    private var _model:Value<Dynamic> = null;
    public var model(get, set):Value<Dynamic>; // would be nice to somehow be able to set this from xml
    private function get_model():Value<Dynamic> {
        return _model;
    }
    private function set_model(value:Value<Dynamic>):Value<Dynamic> {
        if (this.dataSource == null){
            this.dataSource = new ArrayDataSource();
        }
        _model = value;
        _model.add(onModelChanged);
        onModelChanged();
        return value;
    }
    
    private function onModelChanged() {
        for(i in 0...this.dataSource.size) {
            var item:DropDownItem = this.dataSource.get(i);
            if (item.childId == model.data) {
                this.selectedIndex = i;
                break;
            }
        }
    }
}

typedef DropDownItem = {
	childId:Dynamic,
}
