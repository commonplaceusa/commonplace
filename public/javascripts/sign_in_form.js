function sign_in_click(){
	$('#sign_in_button').click(function(){
    	if($('#sign_in_button').hasClass('border')){
        	$('#sign_in_button').removeClass('border').addClass('remove_border');
        	$('#new_user_session').slideDown(300);  
    	}
    	else if($('#sign_in_button').hasClass('remove_border')){
       		$('#new_user_session').slideUp(300, function(){
            	$('#sign_in_button').removeClass('remove_border').addClass('border');
        	});
    	}
	});
}

function drop_login_form()
{
	$('#sign_in_button').removeClass('border').addClass('remove_border');
	$('#new_user_session').show(); 
}