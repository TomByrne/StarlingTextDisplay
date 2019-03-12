package ui;

import haxe.ui.Toolkit;
import openfl.display.Sprite;
import haxe.ui.macros.ComponentMacros;
import haxe.ui.core.Component;
import haxe.ui.core.UIEvent;
import haxe.ui.components.*;
import haxe.ui.core.MouseEvent;
import haxe.ui.data.ArrayDataSource;

import model.Models;
import model.Value;

import starling.utils.HAlign;
import starling.utils.VAlign;

class MainUI extends Sprite
{
	public function new()
	{
		super();

		Toolkit.init();

		var main:Component = ComponentMacros.buildComponent("layouts/MainLayout.xml");
		addChild(main);

		bindComponent(main.findComponent('text'), 'text', Models.text.text); 

		bindSliderText(main.findComponent('sizeText'), main.findComponent('sizeSlider'), Models.text.size);
		bindSliderText(main.findComponent('widthText'), main.findComponent('widthSlider'), Models.text.width);
		bindSliderText(main.findComponent('heightText'), main.findComponent('heightSlider'), Models.text.height);
		bindSliderText(main.findComponent('kerningText'), main.findComponent('kerningSlider'), Models.text.kerning);
		bindSliderText(main.findComponent('leadingText'), main.findComponent('leadingSlider'), Models.text.leading);
		bindSliderText(main.findComponent('snapCharsText'), main.findComponent('snapCharsSlider'), Models.text.snapCharsTo);
		bindSliderText(main.findComponent('zoomText'), main.findComponent('zoomSlider'), Models.workspacePos.scale, 1, true);

		bindDropdown(main.findComponent('hAlign'), Models.text.hAlign);
		bindDropdown(main.findComponent('vAlign'), Models.text.vAlign);
		bindDropdown(main.findComponent('autoSize'), Models.text.autoSize);
		bindDropdown(main.findComponent('smoothing'), Models.text.smoothing);
		bindComponent(main.findComponent('showTextBorder'), 'selected', Models.text.showTextBorder);
		bindComponent(main.findComponent('showBoundsBorder'), 'selected', Models.text.showBoundsBorder);
		bindComponent(main.findComponent('clipOverflow'), 'selected', Models.text.clipOverflow);
		bindComponent(main.findComponent('showTextField'), 'selected', Models.layers.showTextField);
		bindComponent(main.findComponent('showGrid'), 'selected', Models.layers.showGrid);
        
		bindSliderText(main.findComponent('fontScalingText'), main.findComponent('fontScalingSlider'), Models.font.renderScaling, 0.01, false);
		bindSliderText(main.findComponent('fontSuperSamplingText'), main.findComponent('fontSuperSamplingSlider'), Models.font.renderSuperSampling, 1, false);
		bindSliderText(main.findComponent('snapAdvanceText'), main.findComponent('snapAdvanceSlider'), Models.font.renderSnapAdvance, 1, false);
		bindSliderText(main.findComponent('innerPaddingText'), main.findComponent('innerPaddingSlider'), Models.font.renderInnerPadding, 1, false);

        var fontSelect = main.findComponent('fontSelect');
		var updateSelected = bindDropdown(fontSelect, Models.font.selectedFont);
		new FontSelect(fontSelect, main.findComponent('addFont'), updateSelected);

        var button:Button = main.findComponent('clearData');
        button.onClick = function(e:MouseEvent){
            Models.resetModels.dispatch();
        }

        var button:Button = main.findComponent('zoomButton');
        button.onClick = function(e:MouseEvent){
            Models.workspacePos.scale.data = 1;
        }
	}

	public function bindComponent(component:Component, prop:String, model:Value<Dynamic>)
	{
		model.bind(component, prop);
		component.registerEvent(UIEvent.CHANGE, function(e){
			var newValue:Dynamic = Reflect.getProperty(component, prop);
			model.data = newValue; 
		});
	}

	public function bindSliderText(textfield:TextField, slider:HSlider, model:Value<Dynamic>, roundTo:Float = 0, percent:Bool=false)
	{
        var handler = function(){
            var value = model.data;
            if(value == null || Math.isNaN(value)) value = slider.min;

            if(percent){
                value *= 100;
                textfield.text = Std.string(value) + '%';
            }else{
                textfield.text = Std.string(value);
            }
            slider.pos = value;
        }
		model.add(handler);
        handler();
		textfield.registerEvent(UIEvent.CHANGE, function(e){
			model.data = Std.parseFloat(textfield.text) / (percent ? 100 : 1);
		});
		slider.registerEvent(UIEvent.CHANGE, function(e){
			var newValue:Float = slider.pos;
            if(newValue == null || Math.isNaN(newValue)) newValue = slider.min;

            if(roundTo != 0){
                if(roundTo != 1) newValue /= roundTo;
                newValue = Math.round(newValue);
                if(roundTo != 1) newValue *= roundTo;
            }
            if(percent) newValue /= 100;
			model.data = newValue;
		});
	}

	public function bindDropdown(dropdown:DropDown, model:Value<Dynamic>) : Void->Void
	{
        if(dropdown.dataSource == null){
            dropdown.dataSource = new ArrayDataSource();
        }
		var handler = function(){
			for(i in 0 ... dropdown.dataSource.size){
				var item:DropDownItem = dropdown.dataSource.get(i);
				if(item.childId == model.data){
					dropdown.selectedIndex = i;
					break;
				}
			}
		};
		model.add(handler);
		handler();

		dropdown.registerEvent(UIEvent.CHANGE, function(e){
			var item:DropDownItem = dropdown.selectedItem;
			model.data = item.childId;
		});
        return handler;
	}
}

typedef DropDownItem =
{
	childId:Dynamic,
}