package;


import haxe.io.Bytes;
import lime.utils.AssetBundle;
import lime.utils.AssetLibrary;
import lime.utils.AssetManifest;
import lime.utils.Assets;

#if sys
import sys.FileSystem;
#end

@:access(lime.utils.Assets)


@:keep @:dox(hide) class ManifestResources {


	public static var preloadLibraries:Array<AssetLibrary>;
	public static var preloadLibraryNames:Array<String>;
	public static var rootPath:String;


	public static function init (config:Dynamic):Void {

		preloadLibraries = new Array ();
		preloadLibraryNames = new Array ();

		rootPath = null;

		if (config != null && Reflect.hasField (config, "rootPath")) {

			rootPath = Reflect.field (config, "rootPath");

		}

		if (rootPath == null) {

			#if (ios || tvos || emscripten)
			rootPath = "assets/";
			#elseif android
			rootPath = "";
			#elseif console
			rootPath = lime.system.System.applicationDirectory;
			#else
			rootPath = "./";
			#end

		}

		Assets.defaultRootPath = rootPath;

		#if (openfl && !flash && !display)
		openfl.text.Font.registerFont (__ASSET__OPENFL__fonts_roboto_medium_ttf);
		openfl.text.Font.registerFont (__ASSET__OPENFL__fonts_roboto_regular_ttf);
		
		#end

		var data, manifest, library, bundle;

		#if kha

		null
		library = AssetLibrary.fromManifest (manifest);
		Assets.registerLibrary ("null", library);

		if (library != null) preloadLibraries.push (library);
		else preloadLibraryNames.push ("null");

		#else

		data = '{"name":null,"assets":"aoy4:pathy27:styles%2Fdefault%2Fmain.cssy4:sizei1135y4:typey4:TEXTy2:idR1y7:preloadtgoR0y17:styles%2Fmain.cssR2i148R3R4R5R7R6tgoR2i171320R3y4:FONTy9:classNamey32:__ASSET__fonts_roboto_medium_ttfR5y25:fonts%2FRoboto-Medium.ttfR6tgoR0y26:fonts%2FRoboto-Regular.eotR2i163058R3y6:BINARYR5R12R6tgoR0y26:fonts%2FRoboto-Regular.svgR2i240120R3R4R5R14R6tgoR2i162876R3R8R9y33:__ASSET__fonts_roboto_regular_ttfR5y26:fonts%2FRoboto-Regular.ttfR6tgoR0y27:fonts%2FRoboto-Regular.woffR2i86488R3R13R5R17R6tgoR0y28:fonts%2FRoboto-Regular.woff2R2i19960R3R13R5R18R6tgh","rootPath":null,"version":2,"libraryArgs":[],"libraryType":null}';
		manifest = AssetManifest.parse (data, rootPath);
		library = AssetLibrary.fromManifest (manifest);
		Assets.registerLibrary ("default", library);
		

		library = Assets.getLibrary ("default");
		if (library != null) preloadLibraries.push (library);
		else preloadLibraryNames.push ("default");
		

		#end

	}


}


#if kha

null

#else

#if !display
#if flash

@:keep @:bind @:noCompletion #if display private #end class __ASSET__styles_default_main_css extends null { }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__styles_main_css extends null { }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__fonts_roboto_medium_ttf extends null { }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__fonts_roboto_regular_eot extends null { }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__fonts_roboto_regular_svg extends null { }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__fonts_roboto_regular_ttf extends null { }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__fonts_roboto_regular_woff extends null { }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__fonts_roboto_regular_woff2 extends null { }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__manifest_default_json extends null { }


#elseif (desktop || cpp)

@:keep @:file("C:/_sdks/haxelib/haxeui-openfl/1,0,0/./assets/styles/default/main.css") @:noCompletion #if display private #end class __ASSET__styles_default_main_css extends haxe.io.Bytes {}
@:keep @:file("C:/_sdks/haxelib/haxeui-openfl/1,0,0/./assets/styles/main.css") @:noCompletion #if display private #end class __ASSET__styles_main_css extends haxe.io.Bytes {}
@:keep @:font("bin/html5/obj/webfont/Roboto-Medium.ttf") @:noCompletion #if display private #end class __ASSET__fonts_roboto_medium_ttf extends lime.text.Font {}
@:keep @:file("C:/_sdks/haxelib/haxeui-openfl/1,0,0/./assets/fonts/Roboto-Regular.eot") @:noCompletion #if display private #end class __ASSET__fonts_roboto_regular_eot extends haxe.io.Bytes {}
@:keep @:file("C:/_sdks/haxelib/haxeui-openfl/1,0,0/./assets/fonts/Roboto-Regular.svg") @:noCompletion #if display private #end class __ASSET__fonts_roboto_regular_svg extends haxe.io.Bytes {}
@:keep @:font("bin/html5/obj/webfont/Roboto-Regular.ttf") @:noCompletion #if display private #end class __ASSET__fonts_roboto_regular_ttf extends lime.text.Font {}
@:keep @:file("C:/_sdks/haxelib/haxeui-openfl/1,0,0/./assets/fonts/Roboto-Regular.woff") @:noCompletion #if display private #end class __ASSET__fonts_roboto_regular_woff extends haxe.io.Bytes {}
@:keep @:file("C:/_sdks/haxelib/haxeui-openfl/1,0,0/./assets/fonts/Roboto-Regular.woff2") @:noCompletion #if display private #end class __ASSET__fonts_roboto_regular_woff2 extends haxe.io.Bytes {}
@:keep @:file("") @:noCompletion #if display private #end class __ASSET__manifest_default_json extends haxe.io.Bytes {}



#else

@:keep @:expose('__ASSET__fonts_roboto_medium_ttf') @:noCompletion #if display private #end class __ASSET__fonts_roboto_medium_ttf extends lime.text.Font { public function new () { #if !html5 __fontPath = "fonts/Roboto-Medium"; #else ascender = 1900; descender = -500; height = 2400; numGlyphs = 1294; underlinePosition = -200; underlineThickness = 100; unitsPerEM = 2048; #end name = "Roboto Medium"; super (); }}
@:keep @:expose('__ASSET__fonts_roboto_regular_ttf') @:noCompletion #if display private #end class __ASSET__fonts_roboto_regular_ttf extends lime.text.Font { public function new () { #if !html5 __fontPath = "fonts/Roboto-Regular"; #else ascender = 1900; descender = -500; height = 2400; numGlyphs = 1250; underlinePosition = -200; underlineThickness = 100; unitsPerEM = 2048; #end name = "Roboto"; super (); }}


#end

#if (openfl && !flash)

#if html5
@:keep @:expose('__ASSET__OPENFL__fonts_roboto_medium_ttf') @:noCompletion #if display private #end class __ASSET__OPENFL__fonts_roboto_medium_ttf extends openfl.text.Font { public function new () { __fromLimeFont (new __ASSET__fonts_roboto_medium_ttf ()); super (); }}
@:keep @:expose('__ASSET__OPENFL__fonts_roboto_regular_ttf') @:noCompletion #if display private #end class __ASSET__OPENFL__fonts_roboto_regular_ttf extends openfl.text.Font { public function new () { __fromLimeFont (new __ASSET__fonts_roboto_regular_ttf ()); super (); }}

#else
@:keep @:expose('__ASSET__OPENFL__fonts_roboto_medium_ttf') @:noCompletion #if display private #end class __ASSET__OPENFL__fonts_roboto_medium_ttf extends openfl.text.Font { public function new () { __fromLimeFont (new __ASSET__fonts_roboto_medium_ttf ()); super (); }}
@:keep @:expose('__ASSET__OPENFL__fonts_roboto_regular_ttf') @:noCompletion #if display private #end class __ASSET__OPENFL__fonts_roboto_regular_ttf extends openfl.text.Font { public function new () { __fromLimeFont (new __ASSET__fonts_roboto_regular_ttf ()); super (); }}

#end

#end
#end

#end
