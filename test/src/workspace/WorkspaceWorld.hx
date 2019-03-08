package workspace;

import starling.display.Sprite;
import model.Models;

class WorkspaceWorld extends Sprite 
{
    public function new()
    {
        super();

        Models.workspacePos.viewportW.add(onViewportChange);
        Models.workspacePos.viewportH.add(onViewportChange);
        Models.workspacePos.posX.add(onViewportChange);
        Models.workspacePos.posY.add(onViewportChange);
        Models.workspacePos.scale.add(onViewportChange);
        onViewportChange();
    }

    function onViewportChange()
    {
        this.x = Models.workspacePos.viewportW.data /2 - Models.workspacePos.posX.data;
        this.y = Models.workspacePos.viewportH.data /2 - Models.workspacePos.posY.data;
        this.scale = Models.workspacePos.scale.data;
    }
}