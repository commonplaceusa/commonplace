
function setInfoBoxPosition() {
  if ($('#information').get(0) && $('#syndicate').get(0)) {
    if ($(window).scrollTop() - 10 > $('#information').parent().offset().top){
      $('#information').css({'position':'fixed','top': 10, 'width':485});
    } else {
      $('#information').css({'position': 'static'});
    }
  }
}

$(function(){
  window.onscroll = setInfoBoxPosition;
});
