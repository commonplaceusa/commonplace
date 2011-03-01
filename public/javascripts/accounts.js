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
  

  
  //Changes css of clicked 
  $('.unchecked').click(function(){
    if($(this).hasClass('checked')){
      $(this).removeClass('checked');
    }
    else{
      $(this).addClass('checked');
    }
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

function post_feed_ids(){
	var feedIds = new Array();
	var id;	
	$('.checked').parent('.feed').each(function(i){
	id = $(this).children('.feedId').val()	
	feedIds.push({index: i, feed: id});	
	});
	$.ajax({
		type: "POST",
		url: "/accounts/subscribe_to_feeds",
		data: feedIds,
		success: function(){
			window.location = "http://"+document.domain+"/";
		}
	});
}