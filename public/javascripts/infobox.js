
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
  var didscroll = false;  
  $(window).scroll(function() { didscroll = true; });

  setInterval(function() {
    if (didscroll) {
      didscroll = false;
      setInfoBoxPosition();
    }
  }, 100); 
    

  $("body").bind("#information", function(e, content) {
    if (content) {
      $("#information").replaceWith(window.innerShiv(content, false));
    }
    
    renderMaps();    
    
    setInfoBoxPosition();    
    
    $("#file_uploader").change(function() {
      $(this).trigger('image.inline-form');
    });

    initInlineForm();

  });

  $("body").trigger("#information");

});
