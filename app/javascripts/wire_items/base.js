var WireItem = CommonPlace.View.extend({
  showInfoBox: function() {
    if (window.infoBoxManager) {
      this.getInfoBox(function(infoBox) {
        window.infoBoxManager.show(infoBox);
      });
    }
  }
});