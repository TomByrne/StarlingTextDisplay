package workspace;

import starling.core.Starling;
import starling.display.Sprite;
import starling.events.Event;
import starling.assets.AssetManager;
import openfl.system.Capabilities;
import openfl.display3D.Context3DRenderMode;
import openfl.geom.Rectangle;

import model.Models;

class MainWorkspace
{
    private var _starling:Starling;
    private var _assets:AssetManager;

    public function new(stage:openfl.display.Stage)
    {
        Starling.multitouchEnabled = true; // for Multitouch Scene
        
        _starling = new Starling(Sprite, stage, null, null, Context3DRenderMode.AUTO, "auto");
        _starling.stage.stageWidth = 800;
        _starling.stage.stageHeight = 600;
        _starling.enableErrorChecking = Capabilities.isDebugger;
        _starling.skipUnchangedFrames = true;
        _starling.supportBrowserZoom = true;
        _starling.supportHighResolutions = true;
        _starling.simulateMultitouch = true;
        _starling.addEventListener(Event.ROOT_CREATED, function():Void
        {
            setRoot(cast _starling.root);
            Models.starling.contextReady.data = true;
        });

        _starling.start();
    }

    function setRoot(root:Sprite)
    {
        root.addChild(new WorkspaceBackground());

        var world = new WorkspaceWorld();
        root.addChild(world);

        world.addChild(new TextDisplayLayer());
        world.addChild(new TextFieldLayer());
        world.addChild(new WorkspaceGrid());

        new WorkspaceInteractions(root);
    }

    public function setPos(x:Float, y:Float, width:Float, height:Float){
        _starling.stage.stageWidth = Std.int(width);
        _starling.stage.stageHeight = Std.int(height);
        _starling.viewPort = new Rectangle(x, y, width, height);

        Models.workspacePos.viewportW.data = width;
        Models.workspacePos.viewportH.data = height;
    }
}