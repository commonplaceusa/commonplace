
function load_modal(){
	var photo_form = '<div id="photo_form"><div id="webcam"></div><div id="save" onClick="javascript:webcam.capture();">Take a photo</div></div>';
	$.modal(photo_form, {
		opacity:70,
		overlayCss: {backgroundColor:"#000"},
		containerCss:{
		backgroundColor:"#fff",
		borderColor:"#fff",
		height:300,
		padding:0,
		width:340
	},
	overlayClose:true

	});
	$('#webcam').webcam({
		width: 320,
		height: 240,
		mode: "save",
		swffile: "/swf/jscam.swf",
		onTick: function() {},
        onSave: function(data) {},
        onCapture: function() {
			webcam.save('/account/take_photo');
		},
        debug: function() {},
        onLoad: function() {}
	});
	
}
