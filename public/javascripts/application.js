
$.sammy("body")

  .get("#/", setList)

function setInfoBoxPosition() {
  if ($(window).scrollTop() + 10 > $('#info').offset().top){
    $('.info_box').css('position','fixed');
  } else {
    $('.info_box').css('position', 'static');
  }
}

function selectTab(tab) {
  $(document).ready(function(){
    $('header #' + tab).addClass('selected_nav');
  });
};

function setInfoBox() {
  
  $.getJSON(this.path.slice(1), function(response) {
    $("#info").html(response.info_box);
    setInfoBoxPosition();
    renderMaps();
  });
} 

function setList() {
  $.getJSON(this.path.slice(1), function(response) {
    $("#list").html(response.list);
    $("#add").replaceWith(response.add);
    $("#info").html(response.info);
  });
}

$(document).ready(function() {
  $.sammy("body").run()

  window.onscroll = setInfoBoxPosition;
  
  $('ul#wire').accordion({'header': 'a.item_body', 
                          'active': false,
                          'collapsible': true, 
                          'autoHeight': false,
                         });

  $('body').click(function(e) {
    if (e.pageX < (($('body').width() - $('#wrap').width()) / 2)) {
      history.back();
    }
  });
  
  $('a[data-nohistory]').live('click', function(e) {
    e.preventDefault();
    $.sammy("body").runRoute("get",$(this).attr('href'));
  });

  renderMaps();
  
  $('.disabled_link').attr('title', "Coming soon!").tipsy({gravity: 'n'});
  

});
