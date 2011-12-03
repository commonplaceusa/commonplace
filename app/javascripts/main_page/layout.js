
var FixedLayout = function() {
  function adjustProfileBox() {
    var $postBox = $("#post-box");
    var $infoBox = $("#info-box");
    $infoBox.css({
      top: $postBox.outerHeight() + parseInt($postBox.css("top"),10) + 4
    });
    $infoBox.show();
    if ($infoBox.height() < 20) { 
      $infoBox.hide();
    }
  }

  $(window).scroll(adjustProfileBox).resize(adjustProfileBox);

  this.reset = function() {
    adjustProfileBox();
  };
};

var StaticLayout = function() {
  function setInfoBoxPosition() {
    var $el = $("#info-box");
    $el.css({ width: $el.width() });
    if ($el.css("position") == "fixed") { $el.css({ top: 0, bottom: "auto" }); }
    var marginTop = parseInt($el.css("margin-top"), 10);
    var $parent = $el.parent();
    var $footerTop = $("#footer").offset().top;
    var topScroll = $(window).scrollTop();
    var distanceFromTop = $el.offset().top;
    var parentBottomDistanceToTop = $parent.offset().top + $parent.height();

    if ($el.css("position") == "relative") {
      if (distanceFromTop < topScroll) {
        $el.css({ position: "fixed", top: 0, bottom: "auto" });
      }
    } else {
      if (distanceFromTop < parentBottomDistanceToTop + marginTop) {
        $el.css({ position: "relative" });
      } else if (distanceFromTop + $el.height() > $footerTop) {
        var bottom = (topScroll + $(window).height() + 20) - $footerTop;
        $el.css({ top: "auto", bottom: bottom });
      }
    }

  }
  
  $(window).scroll(setInfoBoxPosition);

  this.reset = $.noop;
};
