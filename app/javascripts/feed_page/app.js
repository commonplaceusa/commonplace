
var FeedPageRouter = Backbone.Router.extend({

  routes: {
    "/feeds/:slug": "show",
    "/pages/:slug": "show"
  },

  initialize: function(options) {
    var self = this;
    this.account = options.account;
    this.community = options.community;
    this.feedsList = new FeedsListView({ collection: options.feeds, el: $("#feeds-list") });
    this.feedsList.render();
    this.show(options.feed);
  },

  show: function(slug) {
    var self = this;

    var header = new CommonPlace.shared.HeaderView();
    header.render();
    $("#header").replaceWith(header.el);

    $.getJSON("/api" + this.community.links.groups, function(groups) {
      self.feedsList.select(slug);
      $.getJSON("/api/feeds/" + slug, function(response) {
        var feed = new Feed(response);

        document.title = feed.get('name');

        var feedView = new FeedView({ model: feed, community: self.community, account: self.account, groups: groups });
        window.currentFeedView = feedView;
        feedView.render();

        $("#feed").replaceWith(feedView.el);
      });
    });
  }
});



