
if (window.location.hash.slice(1) != "") {
  window.location.pathname = window.location.hash.slice(1);
  window.location.hash = "";
}

$(function() {

  $.preLoadImages("/images/loading.gif");

  $('a[data-remote]').live('click', function(e) {
    e.preventDefault();
    ajaj("get", $(this).attr('href'), null);
    window.location.hash = $(this).attr('href');
  });
  
  $('div[data-href]').live('click', function(e) {
    e.preventDefault();
    ajaj("get", $(this).attr('data-href'), null);
    window.location.hash = $(this).attr('data-href');
  });
  
  $('div[data-href] a').live('click', function(e) {
    e.stopPropagation();
    if ($(this).attr('data-remote')) {
      e.preventDefault();
      ajaj("get", $(this).attr('href'), null);
      window.location.hash = $(this).attr('href');
    }
  });

  $('form[data-remote]').live('submit', function(e) {
    $('input[type=image]',$(this))
      .replaceWith('<img style="float: right"src="/images/loading.gif">');
    e.preventDefault();
    ajaj("post", $(this).attr('action'), $(this).serialize());
  });

});

function ajaj(method, path, data) {
  $.ajax({
    type: method,
    url: path,
    data: data,
    dataType: "json",
     success: function(response) {
       if (response.redirect_to) {
         window.location = response.redirect_to;
       } else {
         merge(response);
       }
     }
  });
}
