function merge(content) {
  if (content) {
    $.each(content, function(selector, content) {
       if (content) {
         $(selector).replaceWith(window.innerShiv(content, false));
       }
     });
   }
   $('input[placeholder], textarea[placeholder]').placeholder();

   $('.item .post .body, .item .announcement .body, .item .event .body').truncate({max_length: 160});
   $('.disabled_link, a[href=disabled]').attr('title', "Coming soon!").tipsy({gravity: 'n'});
   showTooltips();
   $('#tooltip').html($('#tooltip').attr('title'));
   renderMaps();
   setInfoBoxPosition();

   $('input.date').datepicker({
     prevText: '&laquo;',
     nextText: '&raquo;',
     showOtherMonths: true,
     defaultDate: null
   });

   $(window).trigger('resize.modal');
   setTimeout(function(){$(window).trigger("resize.modal");}, 500);

   $('.disabled_link, a[href=disabled]').attr('title', "Coming soon!").tipsy({gravity: 'n'});

   $("#edit_avatar input").change(function() {
     $(this).parent("form").submit();
   });

  $.polygonInputs();

  $("#deliveries").click(function() {
    $("#deliveries ul").slideToggle();
  });


  initInlineForm();

  $('form.formtastic.user input:text, form.formtastic.user textarea').keydown(function(e) {
    var $input = $(e.currentTarget);
    setTimeout(function(){
      $("#preview")
        .find("[data-track='" + $input.attr('name') + "']")
        .html($input.val());
    }, 10);
  });

  $('form.formtastic.feed input:text, form.formtastic.feed textarea').keydown(function(e) {
    var $input = $(e.currentTarget);
    setTimeout(function() {
      $("#preview")
        .find("[data-track='" + $input.attr('name') + "']")
        .html($input.val());
    }, 10);
  });
}

$(function() {
  merge(null);
});