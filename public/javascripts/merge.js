function merge(content) {
  if (content) {
    $.each(content, function(selector, content) {
       if (content) {
         $(selector).replaceWith(window.innerShiv(content, false));
       }
     });
   }
   $('input[placeholder], textarea[placeholder]').placeholder();

   $('.item .body').truncate({max_length: 160});
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

  $('.inline-form input[type=file]').filestyle({
    image: "/images/upload.gif",
    imagewidth: 100,
    imageheight: 22
  });

  initInlineForm();

  $('.edit_new input:text, .edit_new textarea').keydown(function(e) {
    var $input = $(e.currentTarget);
    setTimeout(function(){
      $('.edit_new .info_box .' + $input.attr('id')).html($input.val());
    }, 10);
  });

  $('form.formtastic.feed input:text, form.formtastic.feed textarea').keydown(function(e) {
    var $input = $(e.currentTarget);
    setTimeout(function() {
      $input.closest('form.feed')
        .find('.info_box')
        .find('.' + $input.attr('id'))
        .html($input.val());
    }, 10);
  });
}

$(function() {
  merge(null);
});