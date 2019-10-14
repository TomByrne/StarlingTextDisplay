package logic;

import font.svg.SvgFontGeneratorConfig;
import starling.time.Tick;
import starling.textures.Texture;
import starling.text.TextField;
import starling.text.model.format.FontRegistry;
import model.Models;
import model.FontModel;
import starling.text.BitmapFont;
import starling.text.model.format.FormatModel;
import font.svg.SvgBitmapFontGenerator;
import font.svg.SvgFont;
import font.CharacterRanges;
import utils.FilePicker;
import openfl.display.BitmapData;
import haxe.Timer;
import openfl.Assets;
import utils.Base64ToBitmapData;

@:access(starling.text.model.format.FormatModel)
class FontListLogic
{
	var defaultFont:BitmapFont;
	var defaultFontInfo1:FontInfo;
	//var defaultFontInfo2:FontInfo;
	//var defaultFontInfo3:FontInfo;
	var fontModel:FontModel;

	public function new(){}

	public function setup()
	{
		Models.starling.contextReady.add(onContextReadyChanged);
		onContextReadyChanged();
	}

	function onContextReadyChanged()
	{
		if(!Models.starling.contextReady.data) return;

		FormatModel.checkDefaultFont();
		defaultFont = FormatModel.baseDefaultFont;

        defaultFontInfo1 = {
            label: 'Default (${defaultFont.name})',
            regName: defaultFont.name,
			builtIn: true,
            type: FontType.DEFAULT,
        }

        /*defaultFontInfo2 = {
            label: 'Roboto Medium (embedded)',
            regName: defaultFont.name,
			filename: 'Roboto-Medium.svg',
			size: 30,
			builtIn: true,
            type: FontType.SVG,
        }

        defaultFontInfo3 = {
            label: 'Roboto Regular (embedded)',
            regName: defaultFont.name,
			filename: 'Roboto-Regular.svg',
			size: 30,
			builtIn: true,
            type: FontType.SVG,
        }*/

		fontModel = Models.font;

		fontModel.addFont.add(onFontAdd);
		
		if(fontModel.selectedFont.data == null) fontModel.selectedFont.data = defaultFont.name;

        var i = 0;
		while(i < fontModel.fonts.data.length)
		{
            var font = fontModel.fonts.data[i];
            if(font.builtIn){
                // Remove old default font
                fontModel.fonts.data.splice(i, 1);
            }else{
		    	processFontInfo(font);
                i++;
            }
		}
        // Add new default font
        fontModel.fonts.data.unshift(defaultFontInfo1);
        fontModel.fonts.dispatch(); // In case processFontInfo tweaked the object

        fontModel.renderScaling.add(rerenderFontsDelayed);
        fontModel.renderSuperSampling.add(rerenderFontsDelayed);
        fontModel.renderSnapAdvance.add(rerenderFontsDelayed);
        fontModel.renderInnerPadding.add(rerenderFontsDelayed);
		

		//loadFont(defaultFontInfo2, 'fonts/Roboto-Medium.svg');
		//loadFont(defaultFontInfo3, 'fonts/Roboto-Regular.svg');
	}

	// For loading SVG fonts that are included in the project
	function loadFont(fontInfo:FontInfo, path:String)
	{
		Assets.loadText(path).then(function(svg){
			fontInfo.fontData = svg;
			fontModel.addFont.dispatch(fontInfo);
			return null;
		});
	}
    
    function rerenderFontsDelayed()
    {
        Tick.once(rerenderFonts);
    }

    function rerenderFonts()
    {
        Tick.remove(rerenderFonts);

		for(font in fontModel.fonts.data)
		{
            if(font != defaultFontInfo1){
                processFontInfo(font);
            }
        }
    }

	function onFontAdd(font:FontInfo)
	{
		if(font.type == null && font.filename != null){
			var ext:String = font.filename.substr(font.filename.lastIndexOf('.') + 1).toLowerCase();
			switch(ext)
			{
				case 'svg': font.type = FontType.SVG;
				case 'fnt': font.type = FontType.ANGEL_FONT;
			}
		}
		if(font.type == null){
			trace('Unknown font type');
			return;
		}

		if(font.size == null){
			font.size = Math.ceil(Models.text.size.data);
		}

        if(font.type == FontType.ANGEL_FONT && font.fontData2 == null) {
            // TODO: Clean this up - Delay to allow file picker to reset
            Timer.delay(function(){
                FilePicker.selectSingleBase64(onFontTextureLoaded.bind(_, font));
            }, 1000);
        }else{
            doFontAdd(font);
        }
	}

    function onFontTextureLoaded(file:FileString, font:FontInfo)
    {
        font.fontData2 = file.content;
        doFontAdd(font);
    }

    function doFontAdd(font:FontInfo)
    {
		if(processFontInfo(font)){
			fontModel.fonts.data.push(font);
			fontModel.fonts.data.sort(sortFonts);
			fontModel.fonts.dispatch();
		}
    }

	function sortFonts(font1:FontInfo, font2:FontInfo) : Int
	{
        if(font1.builtIn && !font2.builtIn) return -1;
        else if(!font1.builtIn && font2.builtIn) return 1;

		var n1:String = font1.label.toLowerCase();
		var n2:String = font2.label.toLowerCase();
		if(n1 < n2) return -1;
		else if(n1 > n2) return 1;
		else return 0;
	}

	function processFontInfo(fontInfo:FontInfo) : Bool
	{
        return switch(fontInfo.type)
        {
            case SVG: processSvgFontInfo(fontInfo);
            case ANGEL_FONT: processAngelFontInfo(fontInfo);
            case DEFAULT: false;
        }
    }
    
	function processAngelFontInfo(fontInfo:FontInfo) : Bool
	{
		if(fontInfo.fontData == null)
		{
			trace('No font data');
			return false;
		}
		if(fontInfo.fontData2 == null)
		{
			trace('No font texture');
			return false;
		}

        var fontData:Xml = Xml.parse(fontInfo.fontData);
        Base64ToBitmapData.go(fontInfo.fontData2, onBitmapLoaded.bind(_, fontData));

        return true;
    }

    function onBitmapLoaded(bitmapData:BitmapData, fontData:Xml)
    {
        if(bitmapData == null){
            trace("Failed to load font texture");
            return;
        }
        var texture:Texture = Texture.fromBitmapData(bitmapData);
        registerFont(new BitmapFont(texture, fontData));
    }

    function registerFont(bitmapFont:BitmapFont)
    {
		var regName = bitmapFont.name + "_" + bitmapFont.size;
		#if (starling < '2.0.0')
		TextField.registerBitmapFont( bitmapFont, regName );
		#else
		TextField.registerCompositor( bitmapFont, regName );
		#end
		FontRegistry.registerBitmapFont(bitmapFont, regName);
    }

	function processSvgFontInfo(fontInfo:FontInfo) : Bool
	{
		if(fontInfo.fontData == null)
		{
			trace('No font data');
			return false;
		}
		if(fontInfo.size == null)
		{
			trace('No font size');
			return false;
		}

		var svgFont:SvgFont = SvgFont.fromString(fontInfo.fontData);

		if(fontInfo.label == null)
		{
			fontInfo.label = svgFont.fontFamily + ' ' + fontInfo.size;
		}
        fontInfo.regName = svgFont.fontFamily + '_' + fontInfo.size;

		var range:Array<Int> = fontInfo.range;
		if(range == null){
			range = CharacterRanges.LATIN_ALL.concat(CharacterRanges.UNICODE_SYMBOLS).concat(CharacterRanges.LATIN_SUPPLEMENT).concat(CharacterRanges.DIGITS);
		}

		var config:SvgFontGeneratorConfig = {
			size: fontInfo.size,
			forceFamily: svgFont.fontFamily,
			superSampling: fontModel.renderSuperSampling.data,
			snapAdvanceXTo: fontModel.renderSnapAdvance.data,
			innerPadding: fontModel.renderInnerPadding.data,
			scaleFactor: fontModel.renderScaling.data,
			gap: Math.ceil(fontInfo.size / 15),
			characters: range,
		}

		var generator:SvgBitmapFontGenerator = new SvgBitmapFontGenerator( svgFont, config );
		generator.addDefaultRegisters();
		Tick.once(doProcess.bind(generator, fontInfo, svgFont), 0);

		return true;
	}

	function doProcess(generator:SvgBitmapFontGenerator, fontInfo:FontInfo, svgFont:SvgFont)
	{
		if(generator.progress < generator.total){
			generator.process(150);
			Tick.once(doProcess.bind(generator, fontInfo, svgFont), 0);
		}else{
			if(fontModel.selectedFont.data == null) fontModel.selectedFont.data = fontInfo.regName;
			else if(fontModel.selectedFont.data == fontInfo.regName) fontModel.selectedFont.dispatch();
		}
	}
}