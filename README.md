## Starling Text Display ![](https://travis-ci.org/TomByrne/StarlingTextDisplay.svg?branch=master)[![Lang](https://img.shields.io/badge/language-haxe-orange.svg?style=flat-square&colorB=EA8220)](http://haxe.org)
An advanced text display for Starling.

Supports:

- Input
- Undo/Redo history
- Cut/Copy/Paste
- Rich formatting (i.e. multiple formats in single display)
- Basic HTML in/out

Uses the same Font objects as Starling's TextField.


Demo
-----
There is a demo available.

[https://tombyrne.github.io/StarlingTextDisplay/index.html](https://tombyrne.github.io/StarlingTextDisplay/index.html)

To add a font, change the size slider to the size you want the bitmap font
to be generated at, then use the plus button to select an SVG Font file.

## Usage

```haxe
// Create a TextDisplay with width=500 and height=400
var textDisplay = new TextDisplay(500, 400);

// Disallow rendering of linebreak characters
textDisplay.allowLineBreaks = false;

// Visually trim the text based on the width/height
textDisplay.clipOverflow = true;

// Disable text wrapping
textDisplay.textWrapping = TextWrapping.NONE;

// Make the TextDisplay automatically adjust it's height
textDisplay.autoSize = TextFieldAutoSize.VERTICAL;

// Set the alignment of text within the TextDisplay
textDisplay.hAlign = HAlign.LEFT;
textDisplay.vAlign = VAlign.TOP;

// Set text as HTML string
textDisplay.htmlText = '<p>text<br/>text</p>';

// Set text as string
textDisplay.text = 'text\ntext';

// Set text limits and ellipsis
textDisplay.maxLines = 10;
textDisplay.maxCharacters = 100;
textDisplay.ellipsis = '...';

// Show bounds for debugging
textDisplay.showBoundsBorder = true;
textDisplay.showTextBorder = true;

// Visually snap characters to every 2nd pixel
textDisplay.snapCharsTo = 2;

// Get text bounds
trace('Text width: ' + textDisplay.textWidth);
trace('Text height: ' + textDisplay.textHeight);
trace('Text bounds: ' + textDisplay.textBounds);

// Listen for links being clicked
textDisplay.addEventListener(LinkEvent.CLICK, onLinkClicked);

// Listen for size changed (useful with autoSize)
textDisplay.addEventListener(TextDisplayEvent.SIZE_CHANGE, onSizeClicked);

// Listen for focus changed
// Check focused using 'hasFocus' or statically using 'TextDisplay.focus'
textDisplay.addEventListener(TextDisplayEvent.FOCUS_CHANGE, onFocusClicked);
```

The formatting of text can be controlled using the `Format` class:

```haxe
// All properties in Format are optional and can be used to 'overlay' settings to existing text
var format = new Format();
format.size = 20.5;
format.face = 'Roboto';
format.color = 0xFF0000;

// Add letter spacing
format.kerning = 1;

// Add line spacing
format.leading = 5;

// Offset font baseline
format.baseline = 1;

// Convert characters to uppercase
format.textTransform = TextTransform.UPPERCASE;

// Add link to text
format.href = 'http://haxe.io';

// Set base default format
textDisplay.defaultFormat = format;

// Format selected characters
textDisplay.setSelectionFormat(format);

// Format range of characters
textDisplay.setFormat(format, 5, 15);

// Get format of selection
textDisplay.getSelectionFormat();

// Get format of character range
textDisplay.getFormat(5, 15);
```

`TextDisplay` also supports input text:

```haxe
// Enable input mode
textDisplay.editable = true;

// Control undo/redo history
textDisplay.undoSteps = 20;
textDisplay.clearUndoOnFocusLoss = true;

// Control visual style of selection box
textDisplay.highlightAlpha = 0.5;
textDisplay.highlightColour = 0x333333;

// Get current selection
textDisplay.getSelectedText();

// Listen for changes to text
textDisplay.addEventListener(Event.CHANGE, onTextChanged);

// Listen for selection changes
textDisplay.addEventListener(Event.SELECT, onSelectionChanged);
```

