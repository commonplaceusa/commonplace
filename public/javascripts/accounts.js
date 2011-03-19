$(document).ready(function(){
	
  //Does the who is bubble stuff
  $('#who_is_info_bubble h3').click(function(){
    var re = new RegExp(/blue-arrow-down/)
    if($('#who_is_info_bubble').css("background-image").match(re)){
      $('#who_is_info_bubble').css("background-image","url(/images/blue-arrow-up.png)")
    }
    else{
      $('#who_is_info_bubble').css("background-image","") 
    }
    	$('#who_is_info').slideToggle();
  });
  
  //Tool tips for main page:
  $('#user_address').tipsy({delayIn: 1000, delayOut: 1000, fade: true, gravity: 'n', trigger: 'focus', live: true, offset: -20 ,fallback: "We need your address so we can place you in a neighborhood within Falls Church!"});
  
  //Style fix for the photoupload stuff
  var style_fix = '<div id="file_input_fix"><input type="text" name="file_fix" id="file_style_fix"></input><div id="browse_button">Browse...</div></div>';
  var take_photo_button = '<div id="take_a_photo" onClick="load_modal();">Take a photo</div>';
	$('#user_avatar_input').append(style_fix)
  // .append(take_photo_button)
    .css("min-height", "54px");
  
	$('#user_avatar').css("opacity", 0);
	$('#user_avatar').css("z-index", 2); 
	$('#user_avatar').css("position", "absolute")
	$('#user_avatar').css("top", "25px")
	$('#user_avatar').css("height", "30px");

  $('#user_avatar').change(function() {
    $("#file_input_fix input").val($(this).val().replace(/^.*\\/,""));
  });
  
  
  // accounts/add_feeds
  $('.add_groups .group, .add_feeds .feed').click(function(){
    $('div', this).toggleClass('checked');
    var $checkbox = $("input:checkbox", this);
    $checkbox.attr("checked", 
                   $checkbox.is(":checked") ? false : "checked");
  });
});

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
