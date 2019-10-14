package ui;

import haxe.ui.containers.Box;
import haxe.ui.events.MouseEvent;
import model.Models;

@:build(haxe.ui.macros.ComponentMacros.build("layouts/MainLayout.xml"))
class MainView extends Box {
    public function new() {
        super();
        percentHeight = 100;
        
        // would be nice to somehow be able to set this from xml
        previewText.model = Models.text.text;
        previewSize.model = Models.text.size;
        previewFont.model = Models.font.selectedFont;
        previewHAlign.model = Models.text.hAlign;
        previewVAlign.model = Models.text.vAlign;
        previewAutoSize.model = Models.text.autoSize;
        previewSmoothing.model = Models.text.smoothing;
        previewWidth.model = Models.text.width;
        previewHeight.model = Models.text.height;
        previewKerning.model = Models.text.kerning;
        previewLeading.model = Models.text.leading;
        previewSnapTo.model = Models.text.snapCharsTo;
        previewShowBorder.model = Models.text.showTextBorder;
        previewShowBoundsBorder.model = Models.text.showBoundsBorder;
        previewClipOverflow.model = Models.text.clipOverflow;
        previewEditable.model = Models.text.editable;
        previewAllowLineBreaks.model = Models.text.allowLineBreaks;
        previewFontScaling.model = Models.font.renderScaling;
        previewFontSuperSampling.model = Models.font.renderSuperSampling;
        previewSnapAdvance.model = Models.font.renderSnapAdvance;
        previewInnerPadding.model = Models.font.renderInnerPadding;
        previewShowTextField.model = Models.layers.showTextField;
        previewShowGrid.model = Models.layers.showGrid;
        previewZoom.model = Models.workspacePos.scale;
    }
    
    @:bind(clearData, MouseEvent.CLICK)
    private function onClearDataClicked(e) {
        Models.resetModels.dispatch();
    }
}