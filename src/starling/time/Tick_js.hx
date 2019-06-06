package starling.time;


@:noCompletion
class Tick_js
{
    static var pending:Array<PendingCall> = [];

    static public function once(handler:Void->Void, priority:Int = 0) : Void
    {
        remove(handler);

        var pendingCall:PendingCall = {
            handler: handler,
            priority: priority,
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
        if(!added){
            pending.push(pendingCall);
            if(pending.length == 1)
            {
                js.Browser.window.requestAnimationFrame(callPending);
            }
        }
        
    }

    static function callPending(delta:Float)
    {
        if(pending.length == 0) return;

        var toCall = pending;
        pending = [];
        for(pendingCall in toCall) pendingCall.handler();
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