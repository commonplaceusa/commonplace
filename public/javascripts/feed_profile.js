$(document).ready(function(){
	$('#post-to-feed h2 nav li:last-child').hide();
	$('#post-to-feed h2 nav ul').hover(function(){
		$('#post-to-feed h2 nav li:last-child').show();
	}, function(){
		$('#post-to-feed h2 nav li:last-child').hide();	
	})

  $("body").bind("create.subscription", function(e, params) {
    $(params.selector).hide("puff", function() { $(this).remove(); });
  });

});
	
