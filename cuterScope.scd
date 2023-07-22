//Cuter Scope

o = Server.default.options;
o.device_("Scarlett 4i4 USB");
o.memSize_(2.pow(20));
~bf = Buffer.alloc(Server.default,4096,2);
~fb = Bus.audio(Server.default,2);
Window.closeAll;
w = Window("lissajous",Window.availableBounds)
.background_(Color.black)
.fullScreen
.onClose_({~topScope.stop; ~bf.free; ~fb.free})
.layout = VLayout(~topScope);
~topScope = ScopeView(w,
	Rect(0,
		0,
		w.view.bounds.width,
		w.view.bounds.height))
.bufnum_(~bf.bufnum)
.server_(Server.default)
.style_(2)
.xZoom_(2)
.yZoom_(2)
.waveColors_([Color.grey,Color.white])
.background_(Color.black)
.start;
// listening to the bus, using ScopeOut2 to write it to the buffer
~af = SynthDef("duoscope", { arg bus, bufnum;
	var z;
	z = In.ar(bus, 2);
	ScopeOut2.ar(z, bufnum);
	Out.ar(0, z);
}).play(
	target: RootNode(Server.default),
	args: [\bus, ~fb.index, \bufnum, ~bf.bufnum],
	addAction: \addToTail // make sure it goes after what you are scoping
);
SynthDef.new(\mic, {
	var sig = SoundIn.ar;
	var bus = ~fb.index;
	Out.ar(
		bus,
		sig
	)
}).play;