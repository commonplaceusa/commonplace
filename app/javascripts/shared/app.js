var CommonPlace = CommonPlace || {};

CommonPlace.render = function(templateName, params) {
  if (!Templates[templateName]) {
    throw new Error("template '" + templateName + "' does not exist");
  };
  return Mustache.to_html(
    Templates[templateName],
    _.extend({}, params, { 
      assets: function() {
        return function(uri, render) {
          return "/assets/" + uri;
        };
      },
      t: function() {
        return function(key,render) {
          var locale = I18N[CommonPlace.community.get('locale')];
          if (!locale) { throw new Error("Unknown locale"); }
          var template = locale[templateName] || {};
          var text = template[key];
          return text ? render(text) : key ;
        };
      } 
    }),
    Templates);
};


CommonPlace.View = Backbone.View.extend({

  render: function() {   
    var  self = this;
    self.aroundRender(function() {
      self.beforeRender();
      $(self.el).html(CommonPlace.render(self.template, self));  
      self.afterRender();
    });
    return this;
  },
  beforeRender: function() {},
                      
  afterRender: function() {},

  aroundRender: function(render) {
    render();
  },

  t: function(key) {
    var locale = I18N[CommonPlace.community.get('locale')];
    if (!locale) { throw new Error("Unknown locale"); }
    var template = locale[this.template] || {};
    var text = template[key];
    return text ? text : key;
  }

});

