$(document).ready(function(){
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
});