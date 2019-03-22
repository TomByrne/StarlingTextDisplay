package starling.text.util;

#if (haxe_ver>=4)
import haxe.ds.List;
import haxe.ds.Map;
#end

import openfl.Vector;
import openfl.display.Bitmap;
import openfl.display.BitmapData;


import starling.display.Quad;
import starling.text.model.layout.Char;
import starling.display.Image;
import starling.display.Image;

#if (starling >= "2.0.0")
	import starling.display.MeshBatch;
#else
	import starling.display.QuadBatch as MeshBatch;
#end

import starling.events.Event;
import starling.text.BitmapChar;
import starling.text.TextDisplay;
import starling.textures.Texture;


/**
 * ...
 * @author P.J.Shand
 */
class CharRenderer
{
	
	static var CharImageMap:Map<BitmapChar, Image> = new Map();

	
	private var textDisplay:TextDisplay;
	private var batches:Map<String, MeshBatch> = new Map();
    
	var characters:Array<Char>;
	var color:Null<UInt>;

	@:allow(starling.text)
	private function new(textDisplay:TextDisplay)
	{
		this.textDisplay = textDisplay;
        textDisplay.charLayout.layoutChanged.add(render);
	}
	
	public function setColor(color:Null<UInt>):Void
	{
		this.color = color;
		
		if (color == null) color = 0;
		#if (starling >= "2.0.0")
		for (quadBatch in batches) 
		{
			quadBatch.color = color;
		}
		#end
	}
	
	public function render() 
	{
		this.characters = textDisplay.contentModel.characters;
		clearBatches();
		
		for (j in 0...characters.length) 
		{
			var char:Char = characters[j];
			if (textDisplay.maxLines != null && char.lineNumber >= textDisplay.maxLines) break;
			//if (char.line.outsizeBounds) break; // needs a bit of a rethink
			
			if (!char.visible) continue;
			if (char.bitmapChar != null) {
				if (char.bitmapChar.texture != null){	
					if (char.bitmapChar.texture.height != 0 && char.bitmapChar.texture.width != 0) {
						
						var image:Image = CharImageMap.get(char.bitmapChar);
						if (image == null){
							image = char.bitmapChar.createImage();
							image.touchable = false;
							CharImageMap.set(char.bitmapChar, image);
						}
						image.scaleX = image.scaleY = char.scale;

                        var smoothing:String = textDisplay.textureSmoothing;
                        if(smoothing == null) smoothing = char.font.smoothing;
                        image.textureSmoothing = smoothing;
						
						image.x = char.x;
						image.y = char.y;
						image.rotation = char.rotation;
						
						if (char.color != null) image.color = char.color;
						else if (color == null) image.color = char.format.color;
						else image.color = color;
						
						//image.touchable = false;
						//images[imageCount] = image;
						//imageCount++;
						
						var quadBatch = batches[char.format.face];
						if (quadBatch==null){
							quadBatch = new MeshBatch();
							quadBatch.batchable = true;
							quadBatch.touchable = false;
							if (textDisplay.numChildren > 0) textDisplay.addChildAt(quadBatch, 1);
							else textDisplay.addChild(quadBatch); 
							batches[char.format.face] = quadBatch;
						}
						#if (starling >= "2.0.0")
							quadBatch.addMesh(image);
						#else
							quadBatch.addImage(image);
						#end
					}
				}
			}
		}
		
		if(textDisplay.color != -1 && textDisplay.color != null) setColor(textDisplay.color);
	}
	
	public function dispose() 
	{
		clearBatches();
		batches = new Map();
	}

    function clearBatches()
    {
        for(quadBatch in batches){
			#if (starling >= "2.0.0")
				quadBatch.clear();
			#else
				quadBatch.reset();
			#end
		}
    }
}