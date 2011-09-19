var play=false;
$(document).ready(function () {
  $('#slides img').css({left: "420px"});
  $('#slides img:first-child').css({left: "0px"});
  
  $('#startSlides').toggle(function(){
    $(this).html('Stop Slideshow');
    play=true;
  }, function(){
    $(this).html('Start Slideshow');
    play =false;
  });
    startSlideshow();
});

function startSlideshow(){
  if(play){
    if($('.active').next('img').length != 0){
      $('.active').removeClass('active').animate({left: "-420px"}, 500).next('img').animate({left: "0px"}, 500).addClass('active');
      $('.slide_info').fadeOut(300, function(){
        $('.slide_info').delay(400).html($('.active').attr('alt')).delay(200).fadeIn();
      });
    }
    else{
     $('#slides img:first-child').addClass('back').appendTo('#slides');
     $('.back').css({left: "420px"}).removeClass('back');
     $('.active').removeClass('active').animate({left: "-420px"}, 500).next('img').animate({left: "0px"}, 500).addClass('active');
     $('.slide_info').fadeOut(300, function(){
        $('.slide_info').delay(400).html($('.active').attr('alt')).delay(200).fadeIn();
      });
    }
  }
  setTimeout("startSlideshow()", 5000);
}