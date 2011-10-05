var GroupPostForm = CommonPlace.View.extend({
  template: "main_page/group-post-form",
  tagName: "form",
  className: "create-group-post",

  groups: function() {
    return _.map(this.options.community.get('groups'), function(g, i) {
      g['class'] = ((i % 2) === 0) ? "even" : "odd";
      return g;
    });
  }
});

