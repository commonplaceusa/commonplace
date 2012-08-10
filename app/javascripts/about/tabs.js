function resetPlaceholders() {

  if(!$.support.placeholder) {
    var active = document.activeElement;
    $('input').focus(function () {
      if ($(this).attr('placeholder') != '' && $(this).val() == $(this).attr('placeholder')) {
        $(this).val('').removeClass('hasPlaceholder');
      }
    }).blur(function () {
      if ($(this).attr('placeholder') != '' && ($(this).val() == '' || $(this).val() == $(this).attr('placeholder'))) {
        $(this).val($(this).attr('placeholder')).addClass('hasPlaceholder');
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
  $('.nav li a').click(function(){

    $('.nav li').removeClass('selected');

    $(this).parent().addClass('selected');

    $('.slide').hide();

    var tab_name = $(this).attr('href');
    activateTab(tab_name);

    return false;
  });

  $(".right #apply-btn").click(function() {
    $(".slide").hide();
    $("#application").show();
    activateAboutPageForm("apply");
  });

  $(".right #nominate-btn").click(function() {
    $(".slide").hide();
    $("#nominate").show();
    activateAboutPageForm("nominate");
  });
});

function activateTab(tab_name) {
  $(".nav li").removeClass('selected');
  $("a[href=" + tab_name + "]").parent().addClass('selected');
  $(".slide").hide();
  $('#' + tab_name).show();
  if (tab_name == "nominate") {
    activateAboutPageForm("nominate");
  } else {
    activateAboutPageForm("register");
  }
  resetPlaceholders();
  return false;
}

function activateAboutPageForm(form_name) {
  $(".right > div").hide();
  if (form_name == "register")
    $("#registration-modal").show();
  else
    $(".right #" + form_name + "-form").show();
  resetPlaceholders();
  return false;
}
