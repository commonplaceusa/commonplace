var CommonPlace = CommonPlace || {};

CommonPlace.View = Backbone.View.extend({
  
  render: function() {
    var self = this;
    self.aroundRender(function() {
      self.beforeRender();
      $(self.el).html(self.renderTemplate(self.template, self));
      self.afterRender();
    });  
    return this;
  },

  beforeRender: function() {},
  afterRender: function() {},
  aroundRender: function(render) {
    render();
  },

  renderTemplate: function(templateName, params) {
    if (!Templates[templateName]) {
      throw new Error("template '" + templateName + "' does not exist");
    }

    return Mustache.to_html(Templates[templateName], params, Templates);
  },

  // these functions work both directly and in templates

  assets: function(path) {
    var makeUrl = function(path) { return "/assets/" + path; };
    return path ? makeUrl(path) : makeUrl;
  },

  t: function(key) {
    var locale = I18N[CommonPlace.community.get('locale')];
    if (!locale) { throw new Error("Unknown locale"); }
    var templateTexts = locale[this.template] || {};
    var translate = function(key, render) {
      render || (render = function(t) { return t; });
      var text = templateTexts[key];
      return text ? render(text) : key;
    };
    return key ? translate(key) : translate;
  },

  markdown: function(text) {
    var markdownify = function(text,render) {
      render || (render = function(t) { return t; });
      text = render(text).replace(/!\[/g, "[");
      return '<div class="markdown">' +
        (new Showdown.converter()).makeHtml(text) +
        '</div>';
    };
    return text ? markdownify(text) : markdownify;
  }

});



var FormView = CommonPlace.View.extend({
  initialize: function(options) {
    this.template = (this.options.template || this.template);
    this.modal = new ModalView({form: this.el});
  },

  afterRender: function() {
    this.modal.render();
  },

  events: {
    "click form a.cancel": "exit",
    "click form a.delete": "deletePost",
    "submit form": "send"
  },

  send: function(e) {
    e.preventDefault();
    this.save();
    this.exit();
  },

  exit: function(e) {
    e && e.preventDefault();
    this.modal.exit();
  },

  deletePost: function(e) {
    e && e.preventDefault();
    var self = this;
    this.remove(function() { self.modal.exit(); });
  }
});
