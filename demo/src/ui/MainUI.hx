package ui;

import haxe.ui.Toolkit;
import haxe.ui.components.*;
import openfl.Lib;
import openfl.display.Sprite;
import openfl.events.Event;

class MainUI extends Sprite
{
	public function new()
	{
		super();

		Toolkit.init();

        var main = new MainView();
        addChild(main);
        
        // So this is interesting, because main was added as a child of a sprite and not the screen
        // it means it never gets resize events from the stage (screen) which means 100% height
        // doesnt work, this is a fix, but it would be better if haxeui could detect this somehow
        // and automatically do this type of thing
        Lib.current.stage.addEventListener(Event.RESIZE, function(e) {
            main.height = Lib.current.stage.stageHeight;
        });
	}
}
