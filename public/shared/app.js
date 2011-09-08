var CommonPlace = CommonPlace || {};

CommonPlace.render = function(name, params) {
  return Mustache.to_html(
    CommonPlace.templates[name],
    _.extend({ auth_token: CommonPlace.auth_token,
               account_avatar_url: CommonPlace.account.get('avatar_url'),
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

