
var FeedsListView = CommonPlace.View.extend({
  template: "feed_page/feeds-list",

  feeds: function() {
    return this.collection;
  },

  afterRender: function() {
    var height = 0;
    $("#feeds-list li").each(function(index) {
      if (index == 9) { return false; }
      height = height + $(this).outerHeight(true);
    });
    $("#feeds-list ul").height(height);
  },

  select: function(slug) {
    this.$("li").removeClass("current");
    this.$("li[data-feed-slug=" + slug + "]").addClass("current");
  }

});
