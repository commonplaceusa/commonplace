
var FixedLayout = function() {
  function adjustProfileBox() {
    var $postBox = $("#post-box");
    var $infoBox = $("#info-box");

    if ($(window).width() < 990) {
      $("#left-column").hide();
      $("#right-column").css({ float: "none", marginLeft: "auto", marginRight: "auto" });
    } else {
      $("#left-column").show();
      $("#right-column").css({ float: '', marginLeft: '', marginRight: '' });
    }
    
    $infoBox.css({
      top: $postBox.outerHeight() + parseInt($postBox.css("top"),10) + 4
    });

    $infoBox.show();
    if ($infoBox.height() < 20) { 
      $infoBox.hide();
    }
  }



  this.reset = function() {
    adjustProfileBox();
  };

  this.bind = function() {
    $(window)
      .bind("scroll.communityLayout", adjustProfileBox)
      .bind("resize.communityLayout", adjustProfileBox);
  };

  this.unbind = function() {
    $(window).unbind(".communityLayout" + this.cid);
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
  this.bind = function() {
    $(window).bind("scroll.communityLayout", setInfoBoxPosition);
  };

  this.unbind = function() {
    $(window).unbind(".communityLayout");
  };
    
  this.reset = $.noop;
};
