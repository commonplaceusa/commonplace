var FeedView = CommonPlace.View.extend({
  template: "feed_page/feed",
  id: "feed",
  initialize: function(options) {
    var self = this;
    this.community = options.community;
    this.account = options.account;
    this.groups = options.groups;
    var feed = this.model;
    var resourceNav, resource, actions, profile, about, header;

    profile = new FeedProfileView({ model: feed });
    about = new FeedAboutView({ model: feed });
    header = new FeedHeaderView({ model: feed, account: self.account });
    resource = new FeedSubResourcesView({ feed: feed, account: self.account });
    resourceNav = resourceNav = new FeedNavView({ model: feed });
    actions = feedActionsView = new FeedActionsView({ feed: feed, 
                                                      groups: this.groups,
                                                      account: self.account,
                                                      community: self.community
                                                    });

    resourceNav.bind("switchTab", function(tab) { resource.switchTab(tab);});

    this.subViews = [profile, about, header, resource, resourceNav, actions];
  },

  afterRender: function() {
    var self = this;
    _(this.subViews).each(function(view) { 
      view.render();
      self.$("#" + view.id).replaceWith(view.el);
    });
  },

  isOwner: function() {
    return this.account.isFeedOwner(this.model);
  }

});