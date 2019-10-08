package utils;

import haxe.crypto.Base64;
import openfl.display.Bitmap;
import openfl.events.Event;
import openfl.display.BitmapData;

class Base64ToBitmapData
{
    
	public static function go(base64:String, onComplete:Null<BitmapData> -> Void):Void 
	{
        var stripToken = "data:image/png;base64,";
        if (base64.indexOf(stripToken) == 0){
            base64 = base64.substr(stripToken.length);
        }
        var bytes = Base64.decode(base64);
        var byteArray = bytes.getData();
        
        var loader = new openfl.display.Loader();
        loader.contentLoaderInfo.addEventListener(Event.COMPLETE, onImageComplete.bind(_, loader, onComplete));
        //ret.contentLoaderInfo.addEventListener(completeEvent, onLoadComplete.bind(_, ret, onComplete, cacheResult ? origUri : null));
        //ret.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, onLoadError.bind(_, onComplete));
        //ret.contentLoaderInfo.addEventListener(SecurityErrorEvent.SECURITY_ERROR, onLoadError.bind(_, onComplete));
        loader.loadBytes(byteArray);
    }
    
	private static function onImageComplete(e:Event, loader:openfl.display.Loader, onComplete:Null<BitmapData>->Void):Void 
	{
		var bitmap:Bitmap = untyped loader.content;
		onComplete(bitmap.bitmapData);
		
		loader.unload();
	}
}