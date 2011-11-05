FeatureSwitching = CommonPlace.View.extend({
  template: "shared.feature-switching",

  events: {
    "change input:checkbox": "toggleFeature",
    "click a.feature-panel-toggle": "toggleFeaturePanel",
    "click button.refresh-page": "refreshPage"
  },

  features: function() {
    return _(window.Features.features()).map(function(feature) {
      return { 
        name: feature, 
        isEnabled: window.Features.isActive(feature) 
      };
    });
  },

  toggleFeature: function(e) {
    var $checkbox = $(e.target);
    window.Features.toggle($checkbox.val());
  },

  canTryFeatures: function() {
    return current_account.canTryFeatures();
  },

  toggleFeaturePanel: function(e) { 
    e.preventDefault();
    this.$("div.feature-panel").slideToggle();
    this.$("a.feature-panel-toggle").toggleClass("shown");
  },

  refreshPage: function() {
    window.location.reload();
  }

});
