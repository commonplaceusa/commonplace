var WireItem = CommonPlace.View.extend({
  showInfoBox: function() {
    var $infoBox = $("#info-box");
    if ($infoBox.size() === 1) {
      this.getInfoBox(function(infoBox) {
        infoBox.render();
        $infoBox.replaceWith(infoBox.el);
        infoBox.setPosition();
      });
    }
  }
});