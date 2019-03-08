package workspace;

import model.Models;

import starling.display.Quad;

class WorkspaceBackground extends Quad
{
    public function new()
    {
        super(100, 100, 0xeeeeee);

        Models.workspacePos.viewportW.bind(this, 'width');
        Models.workspacePos.viewportH.bind(this, 'height');
    }
}