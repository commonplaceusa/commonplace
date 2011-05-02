$(function() {
  
  $.preLoadImages("/images/loading.gif");

  $("#say-something nav a").live('click', function(e) {
    e.preventDefault();
    $.get($(this).attr('href'),
          function(response) {
            if (response) {
              $("#say-something").replaceWith($(response).find("#say-something"));
            }
          });
  });

  $("#whats-happening nav#zones a").live('click', function(e) {
    e.preventDefault();
    $.get($(this).attr('href'),
          function(response) {
            if (response) {
              $('#whats-happening').replaceWith($(response).find("#whats-happening"));
              $("#say-something").replaceWith($(response).find("#say-something"));
            }
          });
  });

  $("#whats-happening li.item").hoverIntent(function(){
    $.get($(this).find('div').first().data('href'),
          function(response) {
            if (response) {
              $('#community-profiles').replaceWith($(response).find("#community-profiles"));
            }
          });
  }, $.noop);

});
