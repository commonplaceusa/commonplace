var NewPostView = CommonPlace.View.extend({
  template: "group_page/new-post",
  id: "new-post",

  initialize: function(options) {
    this.account = options.account;
  },

  afterRender: function() {
    this.$('input[placeholder], textarea[placeholder]').placeholder();
    //this.$("textarea").autoResize();
  },

  account_avatar: function() {
    return this.account.get("avatar_url");
  },

  events: {
    "click button": "postMessage"
  },

  showError: function(response) {
    this.$(".error").text(response.responseText);
    this.$(".error").show();
  },

  postMessage: function(e) {
    e.preventDefault();
    var $form = this.$("form");
    var self = this;
    this.cleanUpPlaceholders();
    this.model.posts.create({
      title: $("[name=title]", $form).val(),
      body: $("[name=body]", $form).val()
    }, {
      success: function() { self.render(); },
      error: function(attribs, response) { self.showError(response); }
    });
  }
});
