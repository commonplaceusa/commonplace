
$.sammy("body")
  .get("close", function(c) {
    $.sammy("body").setLocation(currentIndex($.sammy("body")._location_proxy._last_location));
    $("#modal").html("");

  })
  .get("/", function(){})
  .get(/^\/?$/, function(c) {
    setTimeout(function(){
    $(window).trigger("resize.modal");
    }, 0);
  })
  .defaultCallback(function(c) {
    $.ajax({type: c.verb,
            url: c.path,
            data: c.verb == "get" ? null : c.params,
            dataType: "json",
            success: function(response) {
              if (response.redirect_to) {
                if (response.redirect_to.match(/^http/)) {
                  window.location = response.redirect_to;
                } else {
                  $.sammy("body").setLocation(response.redirect_to);
                  $.sammy("body").runRoute("get", response.redirect_to);
                }
              } else {
                merge(response);
              }
            }
           });
  })

  .setLocationProxy(new Sammy.CPLocationProxy($.sammy('body')));

$(document).ready(function() {
  $.sammy("body").run("/");
  
  window.onscroll = setInfoBoxPosition;
  
  $('.disabled_link, a[href=disabled]').attr('title', "Coming soon!").tipsy({gravity: 'n'});
  $('header nav .disabled_link').attr('title', "Coming soon!").tipsy({gravity: 's'});
  showTooltips();
  
  renderMaps();
  
  $('#modules').sortable();
  $('#modules').disableSelection();
  
  $('ul#wire').accordion({'header': 'a.item_body', 
                          'active': false,
                          'collapsible': true, 
                          'autoHeight': false
                         });

  $("#avatar_to_crop").load(function() {
    $(window).trigger('resize.modal');
    $('#avatar_to_crop').Jcrop({
      aspectRatio: 1,
      onChange: function(args) {
        $("#avatar_x").val(args.x);
        $("#avatar_y").val(args.y);
            $("#avatar_w").val(args.w);
        $("#avatar_h").val(args.h);
      }
    });
  });
  
  $(".tabs").tabs();
  
  $('body').click(function(e) {
    if (e.pageX < (($('body').width() - $('#wrap').width()) / 2)) {
      $('#filters .selected_nav').click();
    }
  });

  $('input.date').datepicker({
    prevText: '&laquo;',
    nextText: '&raquo;',
    showOtherMonths: true,
    defaultDate: null
  });
  
  $('a[data-nohistory]').live('click', function(e) {
    e.preventDefault();
    $.sammy("body").runRoute("get",$(this).attr('href'));
  });
  
  $("#edit_avatar input").change(function() {
    $(this).parent().ajaxSubmit({
      beforeSubmit: function(a,f,o) {
        o.dataType = 'json';
      },
      complete: function(xhr, textStatus) {
        // We have to slice off the inserted html. See AvatarsController
        var json = xhr.responseText.slice(xhr.responseText.indexOf('{'),
                                          xhr.responseText.indexOf('}') +1);
        $.each($.parseJSON(json), function (k,v) {
          $(k).animate({opacity: 0.0}, 500,
                       function () { this.src = v })
            .animate({opacity: 1}, 500);
        });
      }
    });
  });
  $(window).trigger("resize.modal");

});
  
function accordionReplies($replies) {
  if ($replies.get(0)) {
    $("#syndicate .replies").not($replies.get(0)).slideUp();
    $replies.slideDown();
  }
}
