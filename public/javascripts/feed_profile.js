$(document).ready(function(){
	$('#new_event').hide();
	$('form').queue();
	$('#post_tabs li:first-child').next().addClass('inactive').next().addClass('inactive');
	$('#post_tabs li').click(function(){
			$('form').hide();
			
			if($(this).text()==$('#post_tabs li:first-child').text()){
				$('#new_announcement').fadeIn();
			}
			else if($(this).text()==$('#post_tabs li:last-child').text()){
				alert('soon');
			}
			else{
				$('#new_event').fadeIn();
			}
    	$('#post_tabs li').each(function(){
			$(this).addClass('inactive');			
		});
		$(this).removeClass('inactive');
	});
});
	
