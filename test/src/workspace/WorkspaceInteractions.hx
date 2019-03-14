package workspace;

import starling.display.DisplayObject;
import starling.events.TouchEvent;
import starling.events.TouchPhase;
import starling.events.Touch;

import model.Models;

#if html5
import js.html.WheelEvent;
#else
import openfl.events.MouseEvent;
#end

class WorkspaceInteractions
{
    var dispatcher:DisplayObject;
    var isOver:Bool = false;
    var dragTouch:Touch;

    public function new(dispatcher:DisplayObject)
    {
        this.dispatcher = dispatcher;

        #if html5
        js.Browser.document.body.addEventListener("wheel", onHtmlMouseWheel);
        #else
        openfl.Lib.current.stage.addEventListener(MouseEvent.MOUSE_WHEEL, onMouseWheel);
        #end

        dispatcher.addEventListener(TouchEvent.TOUCH, onTouch);
    }

    function onTouch(e:TouchEvent)
    {
        var finished:Int = e.getTouches(dispatcher, TouchPhase.ENDED).length;
        isOver = (e.touches.length - finished) > 0;
        
        if(dragTouch != null){
            var movedTouch = e.getTouch(dispatcher, null, dragTouch.id);
            if(movedTouch != null && movedTouch.phase != TouchPhase.ENDED){
                Models.workspacePos.posX.data -= movedTouch.globalX - movedTouch.previousGlobalX;
                Models.workspacePos.posY.data -= movedTouch.globalY - movedTouch.previousGlobalY;
                dragTouch = movedTouch;
            }else{
                dragTouch = null;
            }
        }else if(!Models.text.hasFocus.data){
            dragTouch = e.getTouch(dispatcher, TouchPhase.BEGAN);
        }
    }
    
	#if html5
	function onHtmlMouseWheel(e:WheelEvent):Void 
	{
		mouseWheel(e.deltaY < 0 ? 1 : -1);
		e.preventDefault();
	}
	#else
	function onMouseWheel(e:MouseEvent):Void 
	{
        mouseWheel(e.delta < 0 ? 1 : -1);
		e.preventDefault();
	}
	#end

    function mouseWheel(num:Float)
    {
        if(!isOver || dragTouch != null) return;
        Models.workspacePos.scale.data += (0.05 * Models.workspacePos.scale.data) * num;
    }
}