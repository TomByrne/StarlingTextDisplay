package model;

import signal.Signal;

class Models
{
    static public var resetModels:Signal = new Signal();

    static public var serialised:Value<String> = new Value();

    static public var workspacePos:WorkspacePosModel = new WorkspacePosModel();
    static public var text:TextModel = new TextModel();
    static public var font:FontModel = new FontModel();
    static public var starling:StarlingModel = new StarlingModel();
    static public var layers:LayersModel = new LayersModel();
}