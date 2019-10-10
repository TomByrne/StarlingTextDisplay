package;

import starling.display.Border;
import starling.display.Scale9Image;
import starling.events.LinkEvent;
import starling.events.TextDisplayEvent;
import starling.text.control.focus.ClickFocus;
import starling.text.control.history.HistoryControl;
import starling.text.control.input.EventForwarder;
import starling.text.control.input.JSCapsLock;
import starling.text.control.input.JSCopyPaste;
import starling.text.control.input.KeyboardInput;
import starling.text.control.input.KeyboardShortcuts;
import starling.text.control.input.MouseInput;
import starling.text.control.input.SoftKeyboardIO;
import starling.text.control.BoundsControl;
import starling.text.display.Caret;
import starling.text.display.ClipMask;
import starling.text.display.Highlight;
import starling.text.display.HitArea;
import starling.text.display.Links;
import starling.text.model.content.Character;
import starling.text.model.content.ContentModel;
import starling.text.model.format.FontRegistry;
import starling.text.model.format.FormatModel;
import starling.text.model.format.Format;
import starling.text.model.format.TextTransform;
import starling.text.model.format.TextWrapping;
import starling.text.model.history.HistoryModel;
import starling.text.model.history.HistoryStep;
import starling.text.model.layout.Alignment;
import starling.text.model.layout.Char;
import starling.text.model.layout.CharLayout;
import starling.text.model.layout.EndChar;
import starling.text.model.layout.Line;
import starling.text.model.layout.Word;
import starling.text.model.selection.Selection;
import starling.text.util.CharacterHelper;
import starling.text.util.CharRenderer;
import starling.text.util.FormatParser;
import starling.text.util.FormatTools;
import starling.text.TextDisplay;
import starling.time.Tick;
import starling.utils.HAlign;
import starling.utils.On;
import starling.utils.SpecialChar;
import starling.utils.Updater;
import starling.utils.VAlign;

class ImportAll
{
	
	static function main(){
		
	}
}