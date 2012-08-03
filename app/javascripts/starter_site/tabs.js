$(document).ready(function(){
  $('.nav li a').click(function(){

    $('.nav li').removeClass('selected');

    $(this).parent().addClass('selected');

    $('.slide').hide();

    var tab_name = $(this).attr('href');
    activateTab(tab_name);

    if (tab_name == "nominate") {
      activateAboutPageForm("nominate");
    } else {
      activateAboutPageForm("register");
    }

    return false;
  });

  $(".right #nominate #apply-btn").click(function() {
    $(".slide").hide();
    $("#application").show();
    activateAboutPageForm("apply");
  });
});

function activateTab(tab_name) {
  $(".nav li").removeClass('selected');
  $("a[href=" + tab_name + "]").parent().addClass('selected');
  $(".slide").hide();
  $('#' + tab_name).show();
  return false;
}

function activateAboutPageForm(form_name) {
  $(".right > div").hide();
  $(".right #" + form_name).show();
  return false;
}
