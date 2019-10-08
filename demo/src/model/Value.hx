package model;

import signal.Signal;

class Value<T> extends Signal
{
    @:isVar public var data(default, set):T;

    function set_data(value:T):T
    {
        if(data == value) return value;
        data = value;
        dispatch();
        return value;
    }

    public function new(?data:T)
    {
        super();
        if(data != null) this.data = data;
    }

    public function bind(target:Dynamic, prop:String)
    {
        var handler = function(){
            Reflect.setProperty(target, prop, data);
        }
        add(handler);
        handler();
    }
}