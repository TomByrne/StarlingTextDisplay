package starling.time;

import haxe.Timer;

@:noCompletion
class Tick_Timer
{
    static var pending:Array<PendingCall> = [];
    static var timer:Timer;

    static public function once(handler:Void->Void, priority:Int = 0) : Void
    {
        remove(handler);

        var pendingCall:PendingCall = {
            handler: handler,
            priority: priority,
        }
        if(timer == null)
        {
            timer = new Timer(10);
            timer.run = callPending;
        }

        var added:Bool = false;
        for(i in 0 ... pending.length)
        {
            var other:PendingCall = pending[i];
            if(other.priority < priority){
                added = true;
                pending.insert(i, pendingCall);
                break;
            }
        }
        if(!added) pending.push(pendingCall);
    }

    static function callPending()
    {
        if(pending.length == 0) return;

        for(pendingCall in pending) pendingCall.handler();
        pending = [];
    }

    static public function remove(handler:Void->Void) : Void
    {
        for(pendingCall in pending){
            if(pendingCall.handler == handler){
                pending.remove(pendingCall);
                break;
            }
        }
    }
}

@:noCompletion
typedef PendingCall =
{
    handler:Void->Void,
    priority:Int,
}