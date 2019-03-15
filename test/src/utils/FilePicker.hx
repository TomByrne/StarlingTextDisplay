package utils;

import haxe.io.Bytes;

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

    static var multi:Bool;
    static var base64:Bool;

    static var onComplete:Dynamic->Void;

    static var files:Array<FileString>;
    static var nativeFiles:FileList;
    static var nativeInd:Int = 0;
    
    static public function selectSingleBase64(onComplete:Null<FileString>->Void)
    {
        if(FilePicker.onComplete != null){
            trace('FilePicker already in use');
            onComplete(null);
            return;
        }

        multi = false;
        base64 = true;

        checkInput();

        FilePicker.onComplete = onComplete;
        input.multiple = multi;
        input.dispatchEvent(clickEvent);
    }
    
    static public function selectMultiString(onComplete:Array<FileString>->Void)
    {
        if(FilePicker.onComplete != null){
            trace('FilePicker already in use');
            onComplete(null);
            return;
        }

        multi = true;
        base64 = false;

        checkInput();

        FilePicker.onComplete = onComplete;
        input.multiple = multi;
        input.dispatchEvent(clickEvent);
    }

    static function checkInput()
    {
        if(input == null)
        {
            input = Browser.document.createInputElement();
            input.type = 'file';
            input.onblur = onFileSelect;
            input.onchange = onFileSelect;

            clickEvent = new MouseEvent('click');

            fileReader = new FileReader();
            fileReader.onerror = onFileError;
            fileReader.onloadend = onFileLoaded;
        }
    }

    static function onFileSelect(e, onComplete:Array<FileString>->Void) {
        if(FilePicker.onComplete == null) return;

        nativeFiles = input.files;
        if(nativeFiles.length == 0){
            callHandler(null);
            return;
        }

        files = [];

        loadNext();
    }

    static function loadNext(){
        if(nativeInd >= nativeFiles.length){
            nativeFiles = null;
            nativeInd = 0;
            if(multi){
                callHandler(files);
            }else{
                callHandler(files[0]);
            }
            return;
        }

        var file = nativeFiles.item(nativeInd);
        if(base64){
            fileReader.readAsDataURL(file);
        }else{
            fileReader.readAsBinaryString(file);
        }
    }

    static function callHandler(value:Dynamic)
    {
        var handler = FilePicker.onComplete;
        FilePicker.onComplete = null;
        handler(value);
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