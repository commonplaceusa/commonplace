var CommonPlace = {};

CommonPlace.WhatsHappening = Backbone.View.extend({
  tagName: "div",
  
  id: "whats-happening",

  events: {
    "click #zones a, #syndicate h3 a" : "navigate"
  },

  navigate: function(e) {
    var self = this,
        $link = $(e.currentTarget);
    
    e.preventDefault();
    self.$('#zones a').removeClass('selected_nav')
      .filter('.' + $link.attr('class'))
      .addClass('selected_nav');

    $.get($link.attr('href'), function(response) {
      if (response) {
        self.$('#syndicate').replaceWith($(window.innerShiv(response,false)).find("#syndicate"));

        $("#syndicate form.new_reply").submit(function(e) {
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

        $("#syndicate .replies a.all-replies").click(function(e) {
          e.preventDefault();
          $(this).hide();
          $(this).siblings("ul").children("li").show();
        });

        $("#syndicate .item a.show-reply-form").click(function(e) {
          e.preventDefault();
          $(this).hide();
          $(this.parent().siblings("div.replies").show();
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
      }
    });
  }
});

CommonPlace.SaySomething = Backbone.View.extend({
  tagName: "div",
  id: "say-something",
  
  events: {
    "click nav a": "navigate"
  },
  
  navigate: function(e) {
    e.preventDefault();
    var self = this,
        $link = $(e.currentTarget);
    
    self.$("nav a").removeClass("current")
      .filter("." + $link.attr('class')).addClass("current");


    $.get($link.attr('href'),
          function(response) {
            if (response) {
              self.$("form").replaceWith($(window.innerShiv(response,false)).find("#say-something form"));
              self.$("h2").replaceWith($(window.innerShiv(response, false)).find("#say-something h2"));
      
              $('input.date').datepicker({
                prevText: '&laquo;',
                nextText: '&raquo;',
                showOtherMonths: true,
                defaultDate: null
              });
            }
          });    
    
  }
  
});

$(function() {
  $.preLoadImages("/images/loading.gif");
  new CommonPlace.WhatsHappening({el: $("#whats-happening")});
  new CommonPlace.SaySomething({el: $("#say-something")});


  $('form.formtastic.feed input:text, form.formtastic.feed textarea').keydown(function(e) {
    var $input = $(e.currentTarget);
    setTimeout(function() {
      $("#preview")
        .find("[data-track='" + $input.attr('name') + "']")
        .html($input.val());
    }, 10);
  });

  $('a.new_subscription').live('click', function(e) {
    e.preventDefault();
    var that = this;
    $.post($(that).attr('href'), function(response) {
      if (response) {
        var $response = $(window.innerShiv(response,false));
        $("#information").replaceWith($response.filter("#information"));
        var $newitem = $response.filter('div.item_div');
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
