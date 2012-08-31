function resetPlaceholders() {
  if(typeof jQuery.support.placeholder === 'undefined') {
    jQuery.support.placeholder = false;
    test = document.createElement('input');
    if('placeholder' in test) jQuery.support.placeholder = true;
  }

  if(!jQuery.support.placeholder) {
    var active = document.activeElement;
    $('input').focus(function () {
      if ($(this).attr('placeholder') != '' && $(this).val() == $(this).attr('placeholder')) {
        $(this).val('').removeClass('hasPlaceholder');
      }
    }).blur(function () {
      if ($(this).attr('placeholder') != '' && ($(this).val() == '' || $(this).val() == $(this).attr('placeholder'))) {
        if (!$(this).hasClass('password')) {
          $(this).val($(this).attr('placeholder')).addClass('hasPlaceholder');
        }
      }
    });
    $('textarea').focus(function () {
      if ($(this).attr('placeholder') != '' && $(this).val() == $(this).attr('placeholder')) {
        $(this).val('').removeClass('hasPlaceholder');
      }
    }).blur(function () {
      if ($(this).attr('placeholder') != '' && ($(this).val() == '' || $(this).val() == $(this).attr('placeholder'))) {
        $(this).val($(this).attr('placeholder')).addClass('hasPlaceholder');
      }
    });
    $('input').blur();
    $('textarea').blur();
    $(active).focus();
    $('form').submit(function () {
      $(this).find('.hasPlaceholder').each(function() { $(this).val(''); });
    });
  }
}

$(document).ready(function(){
  resetPlaceholders();
});
