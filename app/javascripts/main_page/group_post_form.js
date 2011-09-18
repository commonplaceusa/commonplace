var GroupPostForm = CommonPlace.View.extend({
  template: "main_page/group-post-form",
  tagName: "form",
  className: "create-group-post",

  events: {
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
    var groups = this.options.community.get('groups');
    groups[0].selected = "selected";
    return groups;
  }
});