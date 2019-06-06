package starling.time;

import haxe.MainLoop;
import signal.Signal;

/**

For whatever reason, using MainLoop seems to break Lime apps.

**/
@:noCompletion
class Tick_MainLoop
{
    static var signal:Signal;
    static var event:MainEvent;

    static public function once(handler:Void->Void, priority:Int = 0) : Void
    {
        if(signal == null) signal = new Signal();
        if(event == null) event = MainLoop.add(signal.dispatch);
        signal.add(handler, true, priority);
    }

    static public function remove(handler:Void->Void) : Void
    {
        if(signal == null) return;
        signal.remove(handler);

        if(!signal.hasListeners && event != null){
            event.stop();
            event = null;
        }
    }
}