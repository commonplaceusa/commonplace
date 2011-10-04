var NewPostView = CommonPlace.View.extend({
  template: "group_page/new-post",
  id: "new-post",

  initialize: function(options) {
    this.account = options.account;
  },

  afterRender: function() {
    $('input[placeholder], textarea[placeholder]').placeholder();
    this.$("textarea").autoResize();
  },

  account_avatar: function() {
    return this.account.get("avatar_url");
  },

  events: {
    "submit form": "postMessage"
  },

  incomplete: function(fields) {
    var incompleteFields = fields.shift();
    var self = this;
    _.each(fields, function(f) {
      incompleteFields = incompleteFields + " and " + f;
    });
    $(".incomplete-fields").text(incompleteFields);
    $(".incomplete").show();
  },

  postMessage: function(e) {
    var $form = $(e.target);
    var self = this;
    e.preventDefault();
    this.model.posts.create({
      title: $("[name=title]", $form).val(),
      body: $("[name=body]", $form).val()
    }, {
      success: function() { self.render(); },
      error: function(attribs, response) { self.incomplete(response); }
    });
  }
});
