var GroupPostForm = CommonPlace.View.extend({
  template: "main_page.forms.group-post-form",
  tagName: "form",
  className: "create-group-post groupPost group_post",

  groups: function() {
    return _.map(CommonPlace.community.get('groups'), function(g, i) {
      g['class'] = ((i % 2) === 0) ? "even" : "odd";
      return g;
    });
  }
});

