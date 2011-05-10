$(function() {
  
  $.preLoadImages("/images/loading.gif");

  $("#say-something nav a").live('click', function(e) {
    e.preventDefault();
    $.get($(this).attr('href'),
          function(response) {
            if (response) {
              $("#say-something").replaceWith($(window.innerShiv(response,false)).find("#say-something"));
            }
          });
  });

  $("#whats-happening nav#zones a, #syndicate h3 a").live('click', function(e) {
    e.preventDefault();
    $.get($(this).attr('href'),
          function(response) {
            if (response) {
              $('#whats-happening').replaceWith($(window.innerShiv(response,false)).find("#whats-happening"));
              $("#say-something").replaceWith($(window.innerShiv(response,false)).find("#say-something"));
              $("#whats-happening li.item").hoverIntent(function(){
                $.get($(this).find('div').first().data('href'),
                      function(response) {
                        if (response) {
                          $('#community-profiles').replaceWith($(window.innerShiv(response,false)).find("#community-profiles"));
                          setInfoBoxPosition();
                        }
                      });
              }, $.noop);
            }
          });
  });

  $("#syndicate form.new_reply").live("submit", function(e) {
    e.preventDefault();
    var that = this;
    $.post($(that).attr("action"), $(that).serialize(), 
           function(response) {
             if (response) {
               var $replies = $(that).closest("div.replies");
               $replies.replaceWith($(window.innerShiv(response,false)).filter("#" + $replies.attr('id')));
             }
           });
  });

  $('form.formtastic.feed input:text, form.formtastic.feed textarea').keydown(function(e) {
    var $input = $(e.currentTarget);
    setTimeout(function() {
      $("#preview")
        .find("[data-track='" + $input.attr('name') + "']")
        .html($input.val());
    }, 10);
  });

  $("#syndicate .replies a.all-replies").live("click", function(e) {
    e.preventDefault();
    $(this).hide();
    $(this).siblings("ul").children("li").show();
  });

  $("#whats-happening li.item").hoverIntent(function(){
    $.get($(this).find('div').first().data('href'),
          function(response) {
            if (response) {
              $('#community-profiles').replaceWith($(window.innerShiv(response,false)).find("#community-profiles"));
              setInfoBoxPosition();
            }
          });
  }, $.noop);


  $('a.new_subscription').live('click', function(e) {
    e.preventDefault();
    var that = this;
    $.post($(that).attr('href'), function(response) {
      if (response) {
        var $response = $(window.innerShiv(response,false));
        $("#information").replaceWith($response.filter("#information"));
        var $newitem = $response.filter('div.item_div');
        console.log($newitem);
        $("#" + $newitem.attr('id')).replaceWith($newitem);
      }
    });
  });



  $('a.unsubscribe').live('click', function(e) {
    e.preventDefault();
    var that = this;
    $.ajax({
      type: "DELETE",
      url: $(that).attr('href'),
      success: function(response) {
        if (response) {
          var $response = $(window.innerShiv(response,false));
          $("#information").replaceWith($response.filter("#information"));
          var $newitem = $response.filter('div.item_div');
          console.log($newitem);
          $("#" + $newitem.attr('id')).replaceWith($newitem);
        }

      }
    });
  });

  $('a.message_me').live('click', function(e) {
    e.preventDefault();
    var that = this;
    $.get($(that).attr('href'),
          function(response) {
            if (response) {
              $("#modal").replaceWith(
                $(window.innerShiv(response,false)).filter("#modal")
              );
              $(window).trigger('resize.modal');
            }
          });

  });

  $('form.message').live('submit',
                         function(e) {
                           e.preventDefault();
                           var that = this;
                           $.post($(that).attr('action'), $(that).serialize(),
                                  function(response) {
                                    if (response) {
                                      $("#modal").replaceWith(window.innerShiv(response,false));
                                    }
                                    $(window).trigger('resize.modal');
                                  });
                         });
  
});
