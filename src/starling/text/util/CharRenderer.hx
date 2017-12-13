package starling.text.util;

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
	
	private var textDisplay:TextDisplay;
	private var images = new Array<Image>();
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
			quadBatch.color = value;
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
		
		for (image in images){
			image.dispose();
		}
		
		images = new Array<Image>();
		
		setColor(textDisplay.color);
		for (j in 0...characters.length) 
		{
			var char:Char = characters[j];
			if (textDisplay.maxLines != null && char.lineNumber >= textDisplay.maxLines) break;
			//if (char.line.outsizeBounds) break; // needs a bit of a rethink
			
			if (!char.visible) continue;
			if (char.charFormat.bitmapChar != null) {
				if (char.charFormat.bitmapChar.texture != null){	
					if (char.charFormat.bitmapChar.texture.height != 0 && char.charFormat.bitmapChar.texture.width != 0) {
						var image:Image = char.charFormat.bitmapChar.createImage();
						image.scaleX = image.scaleY = char.scale;
						
						image.x = char.x;
						image.y = char.y;
						
						
						/*
						if (color == null) 
							image.color = char.charFormat.format.color;
						else image.color = color;
						*/
						
											
						if (char.charFormat.format.color != null)
						{
							image.color = char.charFormat.format.color;
						}
						else
							image.color = color;
						
						
						image.touchable = false;
						images.push(image);
						
						var quadBatch = quadBatches[char.charFormat.format.face];
						if (quadBatch==null){
							quadBatch = new QuadBatch();
							quadBatch.batchable = true;
							quadBatch.touchable = false;
							textDisplay.addChildAt(quadBatch, 1); 
							quadBatches[char.charFormat.format.face] = quadBatch;
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
	
	public function dispose() 
	{
		for (image in images){
			image.dispose();
		}
	}
}