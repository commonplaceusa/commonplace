//= require json2
//= require showdown
//= require jquery
//= require jquery-ui
//= require jquery-blockUI
//= require highcharts
//= require actual
//= require underscore
//= require mustache
//= require backbone
//= require autoresize
//= require dropkick
//= require truncator
//= require ajaxupload
//= require placeholder
//= require time_ago_in_words
//= require scrollTo
//= require jcrop
//= require plaxo
//= require chosen
//= require highlight-3

//= require config
//= require feature_switches

//= require views
//= require models
//= require wires
//= require wire_items

//= require_tree ./shared
//= require_tree ../templates
//= require en
//= require college

//= require invite_page
//= require faq_page
//= require discount_page
//= require community_page
//= require inbox_page
//= require feed_inbox_page
//= require outbox_page
//= require account_page
//= require stats_page
//= require find_my_neighbors_page
//
//= require facebook

//= require application_initialization

var Application = Backbone.Router.extend({

  initialize: function() {
    this.pages = {
      faq: new FaqPage({ el: $("#main") }),
      invite: new InvitePage({ el: $("#main") }),
      discount: new DiscountPage({ el: $("#main") }),
      community: new CommunityPage({ el: $("#main") }),
      inbox: new InboxPage({ el: $("#main") }),
      outbox: new OutboxPage({ el: $("#main") }),
      feed_inbox: new FeedInboxPage({ el: $("#main") }),
      account: new AccountPage({ el: $("#main") }),
      stats: new StatsPage({ el: $("#main") }),
      find_neighbors: new FindMyNeighborsPage({ el: $("#main") })
    };

    _.invoke(this.pages, "unbind");

    this.bindNewPosts();
  },

  routes: {
    ":community/faq": "faq",
    ":community/invite": "invite",
    ":community/discount": "discount",

    ":community": "community",
    "": "community",
    ":community/list/:tab": "communityWire",
    ":community/share/:tab": "communityPostBox",

    ":community/show/posts/:id": "showPost",
    ":community/show/events/:id": "showEvent",
    ":community/show/group_posts/:id": "showGroupPost",
    ":community/show/announcements/:id": "showAnnouncement",
    ":community/show/users/:id": "showUserWire",

    ":community/message/users/:id": "messageUser",
    ":community/message/feeds/:id": "messageFeed",

    ":community/inbox": "inbox",
    ":community/outbox": "outbox",
    ":community/feed_inbox": "feed_inbox",

    ":community/account": "account",

    ":community/tour": "tour",

    ":community/stats": "stats",

    ":community/find_neighbors": "find_neighbors"
  },

  stats: function(c) { if (CommonPlace.account.get("is_admin")) { this.showPage("stats"); } else { this.community(); } },

  faq: function(c) { this.showPage("faq"); },

  invite: function(c) { this.showPage("invite"); },

  discount: function(c) { this.showPage("discount"); },

  find_neighbors: function(c) { this.showPage("find_neighbors"); },

  community: function(c) {
    this.showPage("community");
    this.pages.community.lists.switchTab("all_posts");
  },

  communityWire: function(c, tab) {
    this.showPage("community");
    this.pages.community.lists.switchTab(tab);
  },

  communityPostBox: function(c, tab) {
    this.community();
    this.pages.community.postBox.switchTab(tab);
  },

  showPost: function(c, id) {
    this.showPage("community");
    this.pages.community.lists.showPost(new Post({links: {self: "/posts/" + id}}));
  },

  showEvent: function(c, id) {
    this.showPage("community");
    this.pages.community.lists.showEvent(new Event({links: {self: "/events/" + id }}));
  },

  showGroupPost: function(c, id) {
    this.showPage("community");
    this.pages.community.lists.showGroupPost(new GroupPost({links: {self: "/group_posts/" + id}}));
  },

  showAnnouncement: function(c, id) {
    this.showPage("community");
    this.pages.community.lists.showAnnouncement(new Announcement({links: {self: "/announcements/" + id}}));
  },

  showUserWire: function(c, id) {
    this.showPage("community");
    this.pages.community.lists.showUserWire(new User({links: {self: "/users/" + id}}));
  },

  messageUser: function(c, id) {
    this.showPage("community");
    var user = new User({ links: { self: "/users/" + id } });
    user.fetch({
      success: function() {
        var form = new MessageFormView({
          model: new Message({ messagable: user })
        });
        form.render();
      }
    });
  },

  messageFeed: function(c, id) {
    this.showPage("community");
    var feed = new Feed({ links: { self: "/feeds/" + id } });
    feed.fetch({
      success: function() {
        var form = new MessageFormView({
          model: new Message({ messagable: feed })
        });
        form.render();
      }
    });
  },

  inbox: function(c) { this.showPage("inbox"); },

  outbox: function(c) { this.showPage("outbox"); },

  feed_inbox: function(c) { this.showPage("feed_inbox"); },

  account: function(c) { this.showPage("account"); },

  tour: function(c) {
    this.community();
    var tour = new Tour({
      el: $("#main"),
      account: CommonPlace.account,
      community: CommonPlace.community
    });
    tour.render();
  },

  showPage: function(name) {
    var page = this.pages[name];
    if (this.currentPage != page) {
      if (this.currentPage) { this.currentPage.unbind(); }
      this.currentPage = page;
      this.currentPage.bind();
      this.currentPage.render();
      window.scrollTo(0,0);
    }
  },

  bindNewPosts: function() {
    var self = this;
    var community = CommonPlace.community;
    var postlikes = [community.posts, community.events, community.groupPosts, community.announcements];
    _.each(postlikes, function(postlike) {
      postlike.on("sync", function() {
        self.navigate("/", true);
        self.community();
      });
    });
  }

});
