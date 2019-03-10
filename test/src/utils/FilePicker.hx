package utils;

#if js
import js.Browser;
import js.html.InputElement;
import js.html.MouseEvent;
import js.html.FileReader;
import js.html.FileList;
#end

class FilePicker
{
    static var input:InputElement;
    static var fileReader:FileReader;
    static var clickEvent:MouseEvent;
    static var onComplete:Array<FileString>->Void;

    static var files:Array<FileString>;
    static var nativeFiles:FileList;
    static var nativeInd:Int = 0;
    
    static public function selectMultiString(onComplete:Array<FileString>->Void)
    {
        if(FilePicker.onComplete != null){
            trace('FilePicker already in use');
            onComplete(null);
            return;
        }

        if(input == null)
        {
            input = Browser.document.createInputElement();
            input.type = 'file';
            input.multiple = true;
            //input.onclick = onFileSelect;
            input.onblur = onFileSelect;
            input.onchange = onFileSelect;

            clickEvent = new MouseEvent('click');

            fileReader = new FileReader();
            fileReader.onerror = onFileError;
            fileReader.onloadend = onFileLoaded;
        }
        FilePicker.onComplete = onComplete;
        input.dispatchEvent(clickEvent);
    }

    static function onFileSelect(e, onComplete:Array<FileString>->Void) {
        if(FilePicker.onComplete == null) return;

        nativeFiles = input.files;
        if(nativeFiles.length == 0){
            FilePicker.onComplete(null);
            return;
        }

        files = [];

        loadNext();
    }

    static function loadNext(){
        if(nativeInd >= nativeFiles.length){
            nativeFiles = null;
            nativeInd = 0;
            FilePicker.onComplete(files);
            FilePicker.onComplete = null;
            return;
        }

        var file = nativeFiles.item(nativeInd);
        fileReader.readAsBinaryString(file);
    }

    static function onFileError(e)
    {
        var file = nativeFiles.item(nativeInd);
        trace('Failed to load file from disk: ${file.name}');
        nativeInd++;
        loadNext();
    }

    static function onFileLoaded(e)
    {
        var file = nativeFiles.item(nativeInd);
        trace('Successfully loaded file from disk: ${file.name}');
        files.push({
            name: file.name,
            content: fileReader.result,
        });
        nativeInd++;
        loadNext();
    }
}

typedef FileString =
{
    name:String,
    content:String,
}