var DynamicLandingResources = CommonPlace.View.extend({
  template: "main_page.dynamic-landing-resources",
  className: "resources",
  
  initialize: function() {
    var self = this;
    
    this.raw = new CommunityWire({ uri: CommonPlace.community.link("landing_wires")});
    
    this.raw.fetch({}, function() {});
  }
});

var LandingPreview = PreviewWire.extend({
  template: "wires.preview-wire",
  _defaultPerPage: 3,
  aroundRender: function(render) { render(); },
  fullWireLink: function() { return this.options.fullWireLink; },
  showMore: function() {},
  areMore: function() { return false; },
  isRecent: function() { return true; }
});
