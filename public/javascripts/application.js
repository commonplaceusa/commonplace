
$.sammy("body")

  .get("#/", setList);

$(document).ready(function() {
  $.sammy("body").run()
  
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

  //uncomment when newlayout is finished
  //renderMaps();
  //window.onscroll = setInfoBoxPosition;
  

  $('.disabled_link').attr('title', "Coming soon!").tipsy({gravity: 'n'});

});
