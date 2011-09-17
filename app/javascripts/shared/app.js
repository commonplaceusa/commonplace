var CommonPlace = CommonPlace || {};

CommonPlace.render = function(name, params) {
  if (!Templates[name]) {
    throw new Error("template '" + name + "' does not exist");
  };
  return Mustache.to_html(
    Templates[name],
    _.extend({ 
               t: function() {
                 return function(key,render) {
                   var text = I18N[CommonPlace.community.get('locale')][name][key];
                   return text ? render(text) : key ;
                 };
               } 
             }, params),
    
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
  }
});

