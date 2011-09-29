var GroupPostForm = CommonPlace.View.extend({
  template: "main_page/group-post-form",
  tagName: "form",
  className: "create-group-post",

  events: {
    "click .group-select a": "selectGroup",
    "submit": "createGroupPost"
  },

  afterRender: function() {
    this.$('input[placeholder], textarea[placeholder]').placeholder();
    this.$("textarea").autoResize();
  },
  
  createGroupPost: function(e) {
    e.preventDefault();
    this.collection.create({
      title: this.$("[name=title]").val(),
      body: this.$("[name=body]").val(),
      group: this.$("[name=group]").val()
    });
    this.render();
  },

  groups: function() {
    return _.map(this.options.community.get('groups'), function(g, i) {
      g['class'] = ((i % 2) === 0) ? "even" : "odd";
      return g;
    });
  },

  selectGroup: function(e) {
    e.preventDefault();
    var id = $(e.currentTarget).attr('href').split('#')[1];
    this.$(".group-name").text($("span", e.currentTarget).text());
    this.$("[name=group]").val(id);
    this.$(".group-select").hide();
    this.$(".group-post-inputs").show();
  }
  
});
