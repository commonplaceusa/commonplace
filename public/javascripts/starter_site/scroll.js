$(document).ready(function(){
  $('.items').css({position: "relative", height: "280px", overflow: "hidden"});
  $('.rotate').css({position: "absolute"});
  $('.rotate').each(function(index){
    $(this).css({left: (index*324)+"px"});
  });
  setTimeout('startRotate()', 5000);
});

function startRotate(){
  $('.rotate').each(function(index){
    $(this).css({left: (index*324)+"px"});
  }).delay(600)
  $('.rotate').animate({left: "-=324px"}, 500);
  $('.rotate:first-child').appendTo('.items');
  setTimeout('startRotate()', 5000);
}