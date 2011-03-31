var pause;
$(document).ready(function () {
  $('#banner_menu').mouseenter(function(){
    pause = true;
  }).mouseleave(function(){
    pause = false;
  })
	$('.bubbles li').each(function(index) {
	  $(this).css({position: "absolute", left: 260*index+"px", bottom: "-200px"}).delay( index * 500 ).slideDown(500);
	});

	setTimeout("slideIt()", 4000);
	//if mouseover the menu item
	$('#banner_menu li').hover(function () {
	  if(!$(this).hasClass('selected')){
	    //select current item
	    $('#banner_menu li').removeClass('selected');
	    $(this).addClass('selected');
	    
	    //grabs li from hidden ul, puts text in bubble.
	    var list = $(this).find("ul").html();
	    $('.bubbles').html(list);
	    
	    $('.bubbles li').each(function(index) {
	     $(this).css({position: "absolute", left: 260*index+"px", bottom: "-200px"}).delay( index * 500 ).slideDown(500);
	    });
    }
    else{
      //Do nothing.  You are already hovered on the selected tab
    }
    
	}).click(function () {
	    return false;
	});
});

function slideIt(){
  if(pause != true){
    if($('.selected').next().length == 0){
      $('.selected').removeClass('selected');
      $('#banner_menu li:first-child').addClass('selected');
    }  
    else{
      $('.selected').removeClass('selected').next().addClass('selected');
    } 
    var list = $('.selected').find("ul").html();
	  $('.bubbles').html(list);
	  $('.bubbles li').each(function(index) {
	    $(this).css({position: "absolute", left: 260*index+"px", bottom: "-200px"}).delay( index * 500 ).slideDown(500);
	  });
  }
	  setTimeout('slideIt()', 5000);
  
}