package logic;

import utils.Storage;
import model.Models;

class ResetModelsLogic
{
    public function new(){}

    public function setup()
    {
        Models.resetModels.add(onReset);
    }

    function onReset()
    {
        Storage.clear();

        #if js
        js.Browser.location.reload();
        #end
    }
}