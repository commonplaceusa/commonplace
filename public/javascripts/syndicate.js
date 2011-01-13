  
function accordionReplies($replies) {
  if ($replies.get(0)) {
    $("#syndicate .replies").not($replies.get(0)).slideUp();
    $replies.slideDown();
  }
}
function accordionItem($item) {
  var $replies = $item.children(".replies"),
      $body = $item.find(".body");
  $("#syndicate .replies").not($replies.get(0)).slideUp();
  $("#syndicate .body").not($body.get(0)).truncate('truncate');
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
});