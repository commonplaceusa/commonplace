
var FeedAdminBar = CommonPlace.View.extend({
  template: "feed_page/feed-admin-bar",
  id: "feed-admin-bar",

  feeds: function() {
    var self = this;
    var feeds = _(this.options.account.get('feeds')).map(function(f) {
      return {name: f.name, slug: f.slug, current: f.id == self.model.id};
    });
    return feeds;
  }
                                           
});
