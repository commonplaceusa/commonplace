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
  return false;
}

function activateAboutPageForm(form_name) {
  $(".right > div").hide();
  if (form_name == "register")
    $("#registration-modal").show();
  else
    $(".right #" + form_name + "-form").show();
  return false;
}
