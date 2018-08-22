package starling.text.util;

import haxe.ds.List;
import haxe.ds.Map;
import openfl.Vector;
import openfl.display.Bitmap;
import openfl.display.BitmapData;


import starling.display.Quad;
import starling.text.model.layout.Char;
import starling.display.Image;
import starling.display.Image;

#if starling2
	import starling.display.MeshBatch;
#else
	import starling.display.QuadBatch;
#end

import starling.events.Event;
import starling.text.BitmapChar;
import starling.text.TextDisplay;
import starling.textures.Texture;


/**
 * ...
 * @author P.J.Shand
 */

#if starling2
	typedef QuadBatch = MeshBatch;
#end

class CharRenderer
{
	
	static var CharImageMap:Map<BitmapChar, Image> = new Map();
	
	private var textDisplay:TextDisplay;
	//private var images:Array<Image> = new Array();
	//private var imageCount:Int = 0;
	private var quadBatches:Map<String, QuadBatch> = new Map();
	private var lineQuads = new Array<Quad>();
	var characters:Array<Char>;
	var color:Null<UInt>;

	@:allow(starling.text)
	private function new(textDisplay:TextDisplay)
	{
		this.textDisplay = textDisplay;
	}
	
	public function setColor(color:Null<UInt>):Void
	{
		this.color = color;
		#if starling2
		for (quadBatch in quadBatches) 
		{
			quadBatch.color = color;
		}
		#end
	}
	
	public function render(characters:Array<Char>) 
	{
		this.characters = characters;
		for(quadBatch in quadBatches){
			#if starling2
				quadBatch.clear();
			#else
				quadBatch.reset();
			#end
		}
		
		//clearImages();
		
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
						//var image:Image = char.bitmapChar.createImage();
						image.scaleX = image.scaleY = char.scale;
						
						image.x = char.x;
						image.y = char.y;
						
						if (color == null) image.color = char.format.color;
						else image.color = color;
						
						//image.touchable = false;
						//images[imageCount] = image;
						//imageCount++;
						
						var quadBatch = quadBatches[char.format.face];
						if (quadBatch==null){
							quadBatch = new QuadBatch();
							quadBatch.batchable = true;
							quadBatch.touchable = false;
							if (textDisplay.numChildren > 0) textDisplay.addChildAt(quadBatch, 1);
							else textDisplay.addChild(quadBatch); 
							quadBatches[char.format.face] = quadBatch;
						}
						#if starling2
							quadBatch.addMesh(image);
						#else
							quadBatch.addImage(image);
						#end
					}
				}
			}
		}
		
		if(textDisplay.color != -1) setColor(textDisplay.color);
	}
	
	/*function clearImages() 
	{
		if(imageCount > 0){
			for (image in images){
				image.dispose();
			}
			imageCount = 0;
			images = [];
		}
	}*/
	
	public function dispose() 
	{
		//clearImages();
		quadBatches = new Map();
	}
}