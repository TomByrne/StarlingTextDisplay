package logic;

import starling.time.Tick;
import model.Models;
import model.FontModel;
import starling.text.BitmapFont;
import starling.text.model.format.FormatModel;
import font.svg.SvgBitmapFontGenerator;
import font.svg.SvgFontDisplays;
import font.svg.SvgFont;
import font.CharacterRanges;

@:access(starling.text.model.format.FormatModel)
class FontListLogic
{
	var defaultFont:BitmapFont;
	var defaultFontInfo:FontInfo;
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

        defaultFontInfo = {
            label: 'Default (${defaultFont.name})',
            regName: defaultFont.name,
            type: FontType.BUILT_IN,
        }

		fontModel = Models.font;
		fontModel.addFont.add(onFontAdd);
		
		if(fontModel.selectedFont.data == null) fontModel.selectedFont.data = defaultFont.name;

        var i = 0;
		while(i < fontModel.fonts.data.length)
		{
            var font = fontModel.fonts.data[i];
            if(font.type == FontType.BUILT_IN){
                // Remove old default font
                fontModel.fonts.data.splice(i, 1);
            }else{
		    	processSvgFontInfo(font);
                i++;
            }
		}
        // Add new default font
        fontModel.fonts.data.unshift(defaultFontInfo);
        fontModel.fonts.dispatch(); // In case processSvgFontInfo tweaked the object

        fontModel.renderScaling.add(rerenderFontsDelayed);
        fontModel.renderSuperSampling.add(rerenderFontsDelayed);
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
            if(font != defaultFontInfo){
                processSvgFontInfo(font);
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
			}
		}
		if(font.type == null){
			trace('Unknown font type');
			return;
		}
		if(font.size == null){
			font.size = Math.ceil(Models.text.size.data);
		}
		
		if(processSvgFontInfo(font)){
			fontModel.fonts.data.push(font);
			fontModel.fonts.data.sort(sortFonts);
			fontModel.fonts.dispatch();
		}
	}

	function sortFonts(font1:FontInfo, font2:FontInfo) : Int
	{
        if(font1 == defaultFontInfo) return -1;
        else if(font2 == defaultFontInfo) return 1;

		var n1:String = font1.label.toLowerCase();
		var n2:String = font2.label.toLowerCase();
		if(n1 < n2) return -1;
		else if(n1 > n2) return 1;
		else return 0;
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
		var svgFontDisplays = SvgFontDisplays.create(svgFont);

		if(fontInfo.label == null)
		{
			fontInfo.label = svgFont.fontFamily + ' ' + fontInfo.size;
		}
        fontInfo.regName = svgFont.fontFamily + '_' + fontInfo.size;

		var range:Array<Int> = fontInfo.range;
		if(range == null){
			range = CharacterRanges.LATIN_ALL.concat(CharacterRanges.UNICODE_SYMBOLS).concat(CharacterRanges.LATIN_SUPPLEMENT);
		}
		var charPadding = Math.ceil(fontInfo.size / 15);

		var bitmapFontGenerator:SvgBitmapFontGenerator = new SvgBitmapFontGenerator( svgFontDisplays, fontInfo.size, 100, svgFont.fontFamily, charPadding, fontModel.renderScaling.data, onFontGenerated.bind(fontInfo, svgFont));
		bitmapFontGenerator.superSampling = fontModel.renderSuperSampling.data;
        bitmapFontGenerator.generateBitmapFont( range );

		return true;
	}

	function onFontGenerated(fontInfo:FontInfo, svgFont:SvgFont)
	{
		if(fontModel.selectedFont.data == null) fontModel.selectedFont.data = fontInfo.regName;
        else if(fontModel.selectedFont.data == fontInfo.regName) fontModel.selectedFont.dispatch();
	}
}