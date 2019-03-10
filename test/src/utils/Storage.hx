package utils;


class Storage
{
    static public function getItem (key:String):String
    {
        return js.Browser.getLocalStorage().getItem(key);
    }

    static public function removeItem (key:String):Void
    {
        return js.Browser.getLocalStorage().removeItem(key);
    }

    static public function setItem (key:String, value:String):Void
    {
        return js.Browser.getLocalStorage().setItem(key, value);
    }

    static public function clear ():Void
    {
        return js.Browser.getLocalStorage().clear();
    }
}