$(document).ready(function(){
  $('.nav li a').click(function(){

    $('.nav li').removeClass('selected');

    $(this).parent().addClass('selected');

    $('.slide').hide();

    activateTab($(this).attr('href'));
    return false;
  });
});

function activateTab(tab_name) {
  $(".nav li").removeClass('selected');
  $("a[href=" + tab_name + "]").parent().addClass('selected');
  $(".slide").hide();
  $('#' + tab_name).show();
  return false;
}
