

var FeedAboutView = CommonPlace.View.extend({
  template: "feed_page/feed-about",
  id: "feed-about",
  about: function() { return this.model.get('about'); }
});

