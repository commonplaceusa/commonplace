

$(function() {
  $(window).bind('resize.modal', function () {
    var $m = $("#modal-content")
    if ($m.get(0)) {
      var w = $m.width(),
      h = $m.height(),
      $b = $(window),
      bw = $b.width(),
      bh = $b.height();
      
      $m.css({top: (bh - h) / 2,
              left: (bw - w) / 2 - 20
             });
    }
  });

  $("#modal-close").live('click', function(e) {
    $("#modal").html("");
  });
});