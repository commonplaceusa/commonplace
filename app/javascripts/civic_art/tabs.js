$(document).ready(function(){
  $('.nav li a').click(function(){

    $('.nav li').removeClass('selected');

    $(this).parent().addClass('selected');

    $('.slide').hide();

    var tab_name = $(this).attr('href');
    activateTab(tab_name);

    return false;
  });
  $('.slide').hide();
  $('.selected').show();

});

function activateTab(tab_name) {
  $(".nav li").removeClass('selected');
  $("a[href=" + tab_name + "]").parent().addClass('selected');
  $(".slide").hide();
  $('#' + tab_name).show();
  $("#registration-modal").show();
  return false;
}
