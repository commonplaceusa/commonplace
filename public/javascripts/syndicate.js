  
function accordionReplies($replies) {
  if ($replies.get(0)) {
    $("#syndicate .replies").not($replies.get(0)).slideUp();
    $replies.slideDown();
  }
}
function accordionItem($item) {
  var $replies = $item.children(".replies"),
      $body = $item.find(".body");
  if ($replies.get(0)) {
    $("#syndicate .replies").not($replies.get(0)).slideUp();
  }
  if ($body.get(0)) {
    $("#syndicate .body").not($body.get(0)).truncate('truncate');
  }
  $replies.slideDown();
  $body.truncate('untruncate');
}

$(function() {
  
  $('ul#wire').accordion({
    'header': 'a.item_body', 
    'active': false,
    'collapsible': true, 
    'autoHeight': false
  });

  $(".item").live('click', function(e) {
    accordionItem($(this));
  });


  $("body").bind("#syndicate", function(e, content) {
    if (content) {
      $("#syndicate").replaceWith(window.innerShiv(content, false));
    }
    $('.item .post .body, .item .announcement .body, .item .event .body').truncate({max_length: 160});    
    showTooltips();
  });

  $("body").bind("show.replies", function(e, params) {
    $(params.selector).replaceWith(window.innerShiv(params.content,false));
  });

  $("body").trigger("#syndicate");

});