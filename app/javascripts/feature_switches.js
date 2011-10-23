
FeatureSwitcher = function(features, backend) {
  
  this._features = _(features).keys();

  this._backend = backend;

  this.features = function() { return this._features; };

  this.activate = function(feature) {
    this.set(feature, true);
  };

  this.deactivate = function(feature) {
    this.set(feature, false);
  };

  this.toggle = function(feature) {
    this.set(feature,
             !this.isActive(feature));
  };
  
  this.isActive = function(feature) {
    return this.get(feature);
  };

  this.set = function(feature, bool) {
    this._backend.setItem(this.keyFor(feature), JSON.stringify(bool));
  };
  
  this.get = function(feature) {
    return JSON.parse(this._backend.getItem(this.keyFor(feature))); 
  };
  
  this.keyFor = function(feature) { return "features:" + feature; };

  var self = this;
  _(features).each(function(bool, feature) {
    self.set(feature, bool || self.isActive(feature));
  });

  return this;
};

Features = new FeatureSwitcher({
  wireSearch: false
}, window.sessionStorage || { 
  setItem: function(name, value) {},
  getItem: function(name) { return false; }
})


;
