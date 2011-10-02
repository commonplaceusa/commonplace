var GroupsListView = CommonPlace.View.extend({
  template: "group_page/groups-list",

  initialize: function(options) {
    this.community = options.community;
  },

  afterRender: function() {
    var height = 0;
    $("#groups-list li").each(function(index) {
      if (index == 9) { return false; }
      height = height + $(this).outerHeight(true);
    });
    $("#groups-list ul").height(height);
  },

  groups: function() {
    return this.collection;
  },

  select: function(slug) {
    this.$("li").removeClass("current");
    this.$("li[data-group-slug=" + slug + "]").addClass("current");
  },

  community_name: function() {
    return this.community.name;
  }

});
