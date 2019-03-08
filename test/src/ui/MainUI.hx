package ui;

import haxe.ui.Toolkit;
import openfl.display.Sprite;
import haxe.ui.macros.ComponentMacros;
import haxe.ui.core.Component;
import haxe.ui.core.UIEvent;
import haxe.ui.components.DropDown;

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
		bindDropdown(main.findComponent('hAlign'), Models.text.hAlign);
		bindDropdown(main.findComponent('vAlign'), Models.text.vAlign);
		bindDropdown(main.findComponent('autoSize'), Models.text.autoSize);
		bindComponent(main.findComponent('width'), 'pos', Models.text.width);
		bindComponent(main.findComponent('height'), 'pos', Models.text.height);
	}

	public function bindComponent(component:Component, prop:String, model:Value<Dynamic>)
	{
		model.bind(component, prop);
		component.registerEvent(UIEvent.CHANGE, function(e){
			var newValue:Dynamic = Reflect.getProperty(component, prop);
			model.data = newValue;
		});
	}

	public function bindDropdown(dropdown:DropDown, model:Value<Dynamic>)
	{
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
	}
}

typedef DropDownItem =
{
	childId:Dynamic,
}