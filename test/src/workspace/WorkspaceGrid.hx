package workspace;

import starling.display.Quad;
import starling.display.Sprite;
import model.Models;

class WorkspaceGrid extends Sprite
{
    public static var GRID_SIZE:Float = 200;
    public static var LINE_THICKNESS:Float = 1;
    public static var LINE_COLOR:UInt = 0x777777;
    public static var LINE_ALPHA:Float = 0.2;

    var linePool:Array<Quad> = [];

    var hLines:Array<Quad> = [];
    var vLines:Array<Quad> = [];

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
        var scale = Models.workspacePos.scale.data;
        var width:Float = Models.workspacePos.viewportW.data / scale;
        var height:Float = Models.workspacePos.viewportH.data / scale;
        var minX:Float = (Models.workspacePos.posX.data / scale) - width / 2;
        var minY:Float = (Models.workspacePos.posY.data / scale) - height / 2;
        var maxX:Float = (Models.workspacePos.posX.data / scale) + width / 2;
        var maxY:Float = (Models.workspacePos.posY.data / scale) + height / 2;

        var x:Float = gridRound(minX, true);
        var i:Int = 0;
        while(x < maxX)
        {
            var quad = vLines[i];
            if(quad == null){
                quad = getQuad();
                vLines[i] = quad;
            }

            quad.x = x;
            quad.y = minY;
            quad.width = LINE_THICKNESS / scale;
            quad.height = (maxY - minY);

            x += GRID_SIZE;
            i++;
        }
        poolLines(vLines, i);

        var y:Float = gridRound(minY, true);
        var i:Int = 0;
        while(y < maxY)
        {
            var quad = hLines[i];
            if(quad == null){
                quad = getQuad();
                hLines[i] = quad;
            }

            quad.x = minX;
            quad.y = y;
            quad.width = (maxX - minX);
            quad.height = LINE_THICKNESS / scale;

            y += GRID_SIZE;
            i++;
        }
        poolLines(hLines, i);
    }
    
    function poolLines(lines:Array<Quad>, i:Int):Void
    {
        while(lines.length - 1 > i)
        {
            var line:Quad = lines.pop();
            removeChild(line);
            linePool.push(line);
        }
    }

    function getQuad():Quad
    {
        var ret:Quad;
        if(linePool.length > 0){
            ret = linePool.pop();
        }else{
            ret = new Quad(10, 10, LINE_COLOR);
        }
        addChild(ret);
        ret.alpha = LINE_ALPHA;
        return ret;
    }

    function gridRound(num:Float, up:Bool) : Float
    {
        num = (num / GRID_SIZE);
        if(up) num = Math.ceil(num);
        else num = Math.floor(num);
        return num * GRID_SIZE;
    }
}