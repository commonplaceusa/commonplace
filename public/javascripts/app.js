
if (window.location.hash.slice(1) != "") {
  window.location.pathname = window.location.hash.slice(1);
  window.location.hash = "";
}

function absToRelPath(href) {
  var match = href.match(/\/\/[^\/]*(\/.*)/);
  if (match && match[1]) {
    return match[1];
  } else {
    return "";
  }
} 

$(function() {

  $.preLoadImages("/images/loading.gif");

  $('a[data-remote]').live('click', function(e) {
    e.preventDefault();
    var path = absToRelPath($(this).get(0).href);
    ajaj("get", path, null);
    window.location.hash = path;
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
      var path = absToRelPath($(this).get(0).href);
      ajaj("get", path, null);
      window.location.hash = path;
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
         if (response.redirect_to.match(/^https?:/)) {
           window.location = response.redirect_to;
         } else {
           window.location.hash = response.redirect_to;
           ajaj("get", response.redirect_to, null);
         }
       } else {
         merge(response);
       }
     }
  });
}
