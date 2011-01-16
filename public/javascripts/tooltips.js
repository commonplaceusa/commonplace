

function showTooltips() {
  $('#tooltip').html(function() {
    return ($('#zones .selected_nav').attr('data-title') || $(this).attr('title'));
  });
};


$(function() {
  
  $('.tooltip, [data-title]')
    .live('mouseover',function() {
      $('#tooltip').html($(this).attr('data-title'));
    })
    .live('mouseout', function() {
      $('#tooltip').html($('#tooltip').attr('title'));
    });

});