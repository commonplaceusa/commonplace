
$.sammy("body")
  .get("close", function(c) {
    $.sammy("body").setLocation(currentIndex($.sammy("body")._location_proxy._last_location));
    $("#modal").html("");
  })

  .around(function(callback) {
    var context = this;
    this.log(context);
    $.ajax({type: context.verb,
            url: context.path,
            data: context.params,
            dataType: "html",
            success: function(response) {
              merge(response, $('body'))
            },
            complete: callback
           });
  })

  .setLocationProxy(new Sammy.CPLocationProxy($.sammy('body')));

$(document).ready(function() {

  $.sammy("body").run();

  $('body').click(function(e) {
    if (e.pageX < (($('body').width() - $('#wrap').width()) / 2)) {
      $('#filters .selected_nav').click();
    }
  });
  
  $('a[data-nohistory]').live('click', function(e) {
    e.preventDefault();
    $.sammy("body").runRoute("get",$(this).attr('href'));
  });
  
  $('.disabled_link, a[href=disabled]').attr('title', "Coming soon!").tipsy({gravity: 'n'});
  $('header nav .disabled_link').attr('title', "Coming soon!").tipsy({gravity: 's'});
  
  showTooltips();
  renderMaps();

  window.onscroll = setInfoBoxPosition;
  
  
});

function accordionReplies($replies) {
  $("#syndicate .replies").not($replies.get(0)).slideUp();
  $replies.slideDown();
}