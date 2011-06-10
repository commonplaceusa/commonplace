
function setInfoBoxPosition() {
  if ($('#information').get(0) && $('#syndicate').get(0)) {
    if ($(window).scrollTop() - 10 > $('#information').parent().offset().top){
      var left;
      if ($(window).scrollLeft() != 0) { left = - $(window).scrollLeft(); } else { left = null }
      $('#information').css({'position':'fixed','top': 10, 'width':485, left: left });
    } else {
      $('#information').css({'position': 'static'});
    }
  }
}

