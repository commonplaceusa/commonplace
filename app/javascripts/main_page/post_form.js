var PostForm = CommonPlace.View.extend({
  template: "main_page/post-form",
  tagName: "form",
  className: "create-neighborhood-post",

  events: {
    "submit": "createPost",
    "click [name=commercial][value=yes]": "showPublicityWarning",
    "click [name=commercial][value=no]": "hidePublicityWarning"
  },

  afterRender: function() {
    this.$('input[placeholder], textarea[placeholder]').placeholder();
    this.$("textarea").autoResize();
  },
  
  createPost: function(e) {
    e.preventDefault();
    var collection = this.collection;
    if ($("[name=commercial]:checked").val() == "yes") {
      collection = this.options.community.announcements;
    }

    collection.create({
      title: this.$("[name=title]").val(),
      body: this.$("[name=body]").val()
    });

    this.render();
  },

  showPublicityWarning: function() {
    this.$("p.warning").show();
  },

  hidePublicityWarning: function() {
    this.$("p.warning").hide();
  }
});