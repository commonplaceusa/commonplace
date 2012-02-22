var CommonPlace = CommonPlace || {};

CommonPlace.View = Backbone.View.extend({

  page_name: "view",
  track: false,

  // Statistics logging

  logVisit: function() {
    if (this.track) {
      if (CommonPlace.visit_id) {
        // UPDATE
        $.ajax({
          type: "PUT",
          dataType: "json",
          url: "/api/stats/update_session",
          data: JSON.stringify({
            path: this.page_name,
            ip_address: CommonPlace.account.get("current_sign_in_ip"),
            original_visit_id: CommonPlace.visit_id,
            commonplace_account_id: CommonPlace.account.get("id")
          })
        });
      } else {
        // CREATE SESSION
        // SAVE SESSION DATA IN CommonPlace.visit_id
        $.ajax({
          type: "POST",
          dataType: "json",
          url: "/api/stats/create_session",
          data: JSON.stringify({
            path: this.page_name,
            ip_address: CommonPlace.account.get("current_sign_in_ip"),
            commonplace_account_id: CommonPlace.account.get("id")
          }),
          success: function(response) { CommonPlace.visit_id = response; }
        });
      }
    }
  },

  render: function() {
    var self = this;
    // trigger around, before, and after hooks
    self.aroundRender(function() {
      self.beforeRender();
      $(self.el).html(self.renderTemplate(self.getTemplate(), self));
      self.afterRender();
      self.logVisit();
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

  attr_accessible: function(attributes) {
    var self = this;
    _.each(attributes, function(attribute) {

        self[attribute] = function() {
          return self.model.get(attribute);
        };

      });
  },

  // these functions work both directly and in templates

  assets: function(path) {
    var makeUrl = function(path) { return "/assets/" + path; };
    return path ? makeUrl(path) : makeUrl;
  },

  getTemplate: function() { return this.options.template || this.template; },

  t: function(key) {
    var locale = I18N[CommonPlace.community.get('locale')];
    if (!locale) { throw new Error("Unknown locale"); }
    var templateTexts = locale[this.getTemplate()] || {};
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
  },

  //TODO: make this part of the placeholder plugin
  cleanUpPlaceholders: function() {
    this.$("[placeholder]").each(function() {
      var input = $(this);
      if (input.val() == input.attr('placeholder')) {
        input.val('');
      }
    });
  },

  isActive: function(feature) {
    return window.Features.isActive(feature);
  },

  bind: $.noop,
  unbind: $.noop,

  community_name: function() { return CommonPlace.community.get('name'); },

  organizer: function() { return CommonPlace.community.get('admin_name'); },

  organizer_email: function() { return CommonPlace.community.get('admin_email'); },

  community_slug: function() { return CommonPlace.community.get('slug'); },

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
    var self = this;
    this.save(function() { self.modal.exit(); });
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
