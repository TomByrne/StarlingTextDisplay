package logic;

import model.Value;
import utils.Storage;
import haxe.Json;

class ModelSerialiserLogic
{
    public function new (){}


    public function add(name:String, model:Dynamic)
    {
        for(field in Reflect.fields(model))
        {
            var propVal:Dynamic = Reflect.field(model, field);
            if(Std.is(propVal, Value))
            {
                var value:Value<Dynamic> = cast propVal;

                var key:String = 'models.' + name + '.' + field;
                value.add(onValueChanged.bind(value, key));

                var data:Dynamic = Storage.getItem(key);
                if(data != null){
                    var valueWrapped:ValueWrapper = Json.parse(data);
                    if(Reflect.hasField(valueWrapped, 'value')){
                        value.data = valueWrapped.value;
                        continue;
                    }
                }
                onValueChanged(value, field);
            }
        }
    }

    public function onValueChanged(value:Value<Dynamic>, key:String)
    {
        var valueWrapped:ValueWrapper = { value:value.data };
        var str:String = Json.stringify(valueWrapped);
        Storage.setItem(key, str);
    }
}

@:noCompletion
typedef ValueWrapper =
{
    value:Dynamic,
}