$.sammy("body")

  .get("#manage", function () {
    this.redirect(this.params["manage"])
  })
  .get("#close", function(c) {
    $("#modal").html("");
    $.sammy("body").setLocation(currentIndex($.sammy("body")._location_proxy._last_location));
  })

  .setLocationProxy(new Sammy.CPLocationProxy($.sammy('body')));

$(function() {
  $.sammy("body").run();
  renderMaps();
  $('input.date').datepicker({
    prevText: '&laquo;',
    nextText: '&raquo;',
    showOtherMonths: true,
    defaultDate: null, 
  });
  
  $('#modules').sortable({
    update: function(event, ui) {
      var params = 
        $.extend(this.params, 
                 {
                   fields: 
                   $.map($("#modules").sortable("toArray"),
                         function(m) { return m.replace("field_", ""); })
                 });
      $.post("/management/organizations/" 
             + $("#modeles").attr("data-organization") 
             + "/profile_fields/order", params, function () { }, "json");
    }
  });
  $('#modules').disableSelection();

  $(".tabs").tabs();
    
  $('#close_modal').click(function() {
    $.modal.close();
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
      },

    });
  });

  $('ul#wire').accordion({'header': 'a.item_body', 
                          'active': false,
                          'collapsible': true, 
                          'autoHeight': false,
                         });

  $('.disabled_link').attr('title', "Coming soon!").tipsy({gravity: 'n'});
  
});