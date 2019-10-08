package model;

class WorkspacePosModel
{
    public function new(){}


    public var viewportW:Value<Float> = new Value(100.0);
    public var viewportH:Value<Float> = new Value(100.0);


    public var posX:Value<Float> = new Value(0.0);
    public var posY:Value<Float> = new Value(0.0);
    public var scale:Value<Float> = new Value(1.0);

}