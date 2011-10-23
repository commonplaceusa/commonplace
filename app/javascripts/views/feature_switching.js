FeatureSwitching = CommonPlace.View.extend({
  template: "shared.feature-switching",

  events: {
    "change input:checkbox": "toggleFeature",
    "click a.feature-list-toggle": "toggleFeatureList"
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
    return this.options.account.canTryFeatures();
  },

  toggleFeatureList: function(e) { 
    e.preventDefault();
    this.$("ul.feature-list").slideToggle();
    this.$("a.feature-list-toggle").toggleClass("shown");
  }
});
