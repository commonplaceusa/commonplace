
var InfoBox = CommonPlace.View.extend({
  id: "info-box",
  
  setPosition: function(infoBoxEl) {
    var $el = infoBoxEl ? $(infoBoxEl) : $(this.el);
    var marginTop = parseInt($el.css("margin-top"), 10);
    var $parent = $el.parent();
    var topScroll = $(window).scrollTop();
    var distanceFromTop = $el.offset().top;
    var parentBottomDistanceToTop = $parent.offset().top + $parent.height();

    $el.css({ width: $el.width() }); 

    if ($el.css("position") == "relative") {
      if (distanceFromTop < topScroll) {
        $el.css({ position: "fixed", top: 0 });
      }
    } else {
      if (distanceFromTop < parentBottomDistanceToTop + marginTop) {
        $el.css({ position: "relative" });
      }
    }
  }
});
