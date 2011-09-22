var WireItem = CommonPlace.View.extend({
  showInfoBox: function() {
    if (window.infoBoxManager) {
      this.getInfoBox(function(infoBox) {
        window.infoBoxManager.show(infoBox);
      });
    }
  },

  showProfile: function() {
    if (window.infoBoxManager) {
      this.getProfile(function(profile) {
        window.infoBoxManager.show(profile);
      });
    }
  }
});
