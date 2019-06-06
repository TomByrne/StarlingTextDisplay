package starling.time;

#if js
typedef Tick = Tick_js;
#else
typedef Tick = Tick_MainLoop;
#end