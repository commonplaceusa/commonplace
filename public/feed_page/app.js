CommonPlace.render = function(name, params) {
  return Mustache.to_html(
    CommonPlace.templates[name], 
    params,
    CommonPlace.templates
  );
};


var FeedPageRouter = Backbone.Controller.extend({

  routes: {
    "/feeds/:slug/profile": "show"
  },

  initialize: function(options) {
    this.account = options.account;
  },

  show: function(slug) {
    var self = this;
    $.getJSON("/api/feeds/" + slug, function(feed) {
      new FeedProfileView({ model: feed, el: $("#feed-profile")}).render();
      
      new FeedHeaderView({ model: feed, account: self.account, el: $("#feed-header") }).render();

      new FeedActionsView({ el: $("#feed-actions") }).render();
      
      new FeedNavView({ model: feed, el: $("#feed-nav") }).render();

      $.getJSON("/api/communities/1/feeds", function(feeds) {
        new FeedsListView({ model: feed, collection: feeds, el: $("#feeds-list") }).render();
      });
    });
  }
});

var FeedHeaderView = Backbone.View.extend({
  initialize: function(options) { this.account = options.account },

  render: function() {
    $(this.el).html(CommonPlace.render("header", this.model));
    return this;
  }
});

var FeedProfileView = Backbone.View.extend({
  render: function() {
    $(this.el).html(CommonPlace.render("feed-profile", this.model));
    return this;
  }
});

var FeedsListView = Backbone.View.extend({
  render: function() {
    var self = this;
    $(this.el).html(CommonPlace.render("feeds-list", { 
      feeds: _(this.collection).map(function(feed) {
        return _(feed).extend({ isCurrent: feed['id'] == self.model['id'] });
      })
    }));
    return this;
  }
});

var FeedNavView = Backbone.View.extend({
  render: function() {
    $(this.el).html(CommonPlace.render("nav", { 
      postsUrl: this.postsUrl(),
      membersUrl: this.membersUrl(),
      postsClass: this.isCurrentUrl(this.postsUrl()) ? "current" : "",
      membersClass: this.isCurrentUrl(this.membersUrl()) ? "current" : ""
    }));
    return this;
  },

  postsUrl: function() { return "/feeds/" + this.model['id']  },
  membersUrl: function() { return "/feeds/" + this.model['id'] + "/members" },
  isCurrentUrl: function(string) { return window.location.hash.slice(1) == string }
  
});

var FeedActionsView = Backbone.View.extend({
  render: function() {
    $(this.el).html(CommonPlace.render("feed-actions", {
      postAnnouncementClass: "current"
    }));
  }
});

var Feed


$(function() {
  $.getJSON("/api/account", function(account) {

    new FeedPageRouter({ account: account });
    window.location.hash = window.location.pathname;
    Backbone.history.start();

  });
});