var CommonPlace = CommonPlace || {};

CommonPlace.render = function(name, params) {
  if (!CommonPlace.templates[name]) {
    throw new Error("template '" + name + "' does not exist");
  };
  return Mustache.to_html(
    CommonPlace.templates[name],
    _.extend({ 
               t: function() {
                 return function(key,render) {
                   var text = CommonPlace.text[CommonPlace.community.get('locale')][name][key];
                   return text ? render(text) : key ;
                 };
               } 
             }, params),
    
    CommonPlace.templates);
};

Mustache.template = function(templateString) {
  return templateString;
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

