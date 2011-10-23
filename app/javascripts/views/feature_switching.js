FeatureSwitching = CommonPlace.View.extend({
  template: "shared.feature-switching",

  events: {
    "change input:checkbox": "toggleFeature",
    "click a.feature-list-toggle": "toggleFeatureList"
  },

  features: function() {
    return _(window.Features).map(function(enabled, feature) {
      return { name: feature, isEnabled: enabled };
    });
  },

  toggleFeature: function(e) {
    var $checkbox = $(e.target);
    window.Features[$checkbox.val()] = $checkbox.is(":checked");
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
