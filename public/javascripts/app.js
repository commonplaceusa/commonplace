var CommonPlace = CommonPlace || {};

Mustache.template = function(templateString) {
  return templateString;
};


$(function() {
  $.preLoadImages("/images/loading.gif");


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
