package;

import openfl.display.Bitmap;
import openfl.display.Sprite;
import openfl.events.Event;
import openfl.display.StageScaleMode;

import ui.MainUI;
import workspace.MainWorkspace;

class TextDisplayTest extends openfl.display.Sprite
{
    private var _background:Bitmap;
    private var workspace:MainWorkspace;

    public function new()
    {
        super();
        if (stage != null) onAddedToStage(null);
        else addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
    }

    function onAddedToStage(event:Dynamic):Void
    {
        removeEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
        stage.scaleMode = StageScaleMode.NO_SCALE;
        
        addChild(new MainUI());
        workspace = new MainWorkspace(stage);

        stage.addEventListener(Event.RESIZE, onResize, false, 1000000, true);
        onResize(null);
    }
    
    function onResize(e:Event):Void
    {
        workspace.setPos(200, 0, stage.stageWidth - 200, stage.stageHeight);
    }
}