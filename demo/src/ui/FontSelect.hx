package ui;

import haxe.ui.components.DropDown;
import haxe.ui.components.Button;
import haxe.ui.core.UIEvent;
import haxe.ui.core.MouseEvent;
import utils.FilePicker;
import model.Models;

class FontSelect
{
    var dropdown:DropDown;
    var browseButton:Button;
    var updateSelected:Void->Void;

    public function new(dropdown:DropDown, browseButton:Button, updateSelected:Void->Void)
    {
        this.dropdown = dropdown;
        this.browseButton = browseButton;
        this.updateSelected = updateSelected;

        browseButton.onClick = function(e:MouseEvent){
            FilePicker.selectMultiString(onFiles);
        }

        Models.font.fonts.add(onFontsChanged);
        onFontsChanged();
    }

    function onFontsChanged()
    {
        dropdown.dataSource.clear();
        for(font in Models.font.fonts.data){
            //<item value="HAlign: Left" childId="left" />
            dropdown.dataSource.add( { value:font.label, childId:font.regName } );
        }
        if(Models.font.fonts.data.length > 0 && Models.font.selectedFont.data != null) updateSelected();
    }

    function onFiles(files:Array<FileString>)
    {
        if(files == null) return;
        
        for(file in files){
            var fontInfo = {
                filename: file.name,
                fontData: file.content,
            }
            Models.font.addFont.dispatch(fontInfo);
        }
    }
}