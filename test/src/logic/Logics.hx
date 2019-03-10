package logic;

import model.Models;

class Logics
{
    static public var modelSerialiser:ModelSerialiserLogic = new ModelSerialiserLogic();
    static public var fontListLogic:FontListLogic = new FontListLogic();
    static public var resetModelsLogic:ResetModelsLogic = new ResetModelsLogic();

    static public function setup(){
        modelSerialiser.add('workspacePos', Models.workspacePos);
        modelSerialiser.add('text', Models.text);
        modelSerialiser.add('font', Models.font);
        modelSerialiser.add('layers', Models.layers);

        fontListLogic.setup();
        resetModelsLogic.setup();
    }
}