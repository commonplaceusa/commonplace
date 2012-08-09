$(document).ready(function(){
  $('.tabs li a').click(function(){
    
    $('.tabs li a').removeClass('current');
    
    $(this).addClass('current');
    
    $('.panes div').hide();
    
    if($(this).parent().attr('id')=="ini"){
      $('#init').show();
    }
    else if($(this).parent().attr('id')=="tec"){
      $('#tech').show();
    }
    else if($(this).parent().attr('id')=="org"){
      $('#organ').show();
    }
    return false;
  });
});