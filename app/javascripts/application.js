//= require json2
//= require showdown
//= require jquery.1.7
//= require jquery-ui.1.8
//= require jquery-blockUI
//= require jquery-badger
//= require jquery-backgroundSize
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
//= require modernizr

//= require config
//= require feature_switches

//= require views
//= require models
//= require wires
//= require wire_items

//= require_tree ./shared
//= require_tree ../templates
//= require en

//= require invite_page
//= require faq_page
//= require discount_page
//= require main_page
//= require inbox_page
//= require feed_inbox_page
//= require outbox_page
//= require account_page
//= require stats_page
//
//= require facebook

//= require_tree ./contacts

//= require application_initialization

var Application = Backbone.Router.extend({

  initialize: function() {
    Backbone.View.prototype.eventAggregator = _.extend({}, Backbone.Events);
    var header = new CommonPlace.shared.HeaderView({ el: $("#header") });
    header.render();

    $("#notification").hide();

    this.pages = {
      faq: new FaqPage({ el: $("#main") }),
      invite: new InvitePage({ el: $("#main") }),
      discount: new DiscountPage({ el: $("#main") }),
      community: new CommonPlace.CommunityPage({ el: $("#main") }),
      inbox: new InboxPage({ el: $("#main") }),
      outbox: new OutboxPage({ el: $("#main") }),
      feed_inbox: new FeedInboxPage({ el: $("#main") }),
      account: new AccountPage({ el: $("#main") }),
      stats: new StatsPage({ el: $("#main") })
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

    ":community/pages/:id": "showFeedPage",
    ":community/groups/:id": "showGroupPage",

    ":community/show/posts/:id": "showPost",
    ":community/show/events/:id": "showEvent",
    ":community/show/group_posts/:id": "showGroupPost",
    ":community/show/announcements/:id": "showAnnouncement",
    ":community/show/users/:id": "showUserWire",
    ":community/show/transactions/:id": "showTransaction",

    ":community/message/users/:id": "messageUser",
    ":community/message/feeds/:id": "messageFeed",

    ":community/inbox": "inbox",
    ":community/outbox": "outbox",
    ":community/feed_inbox": "feed_inbox",

    ":community/account": "account",

    ":community/registration": "tour",

    ":community/stats": "stats",

  },

  stats: function(c) {
    if (CommonPlace.account.get("is_admin")) {
      this.showPage("stats");
    } else {
      this.community();
    }
  },

  faq: function(c) { this.showPage("faq"); },

  invite: function(c) { this.showPage("invite"); },

  discount: function(c) { this.showPage("discount"); },

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

  showTransaction: function(c, id) {
    this.showPage("community");
    this.pages.community.lists.showTransaction(new Transaction({links: {self: "/transactions/" + id }}));
  },

  showGroupPost: function(c, id) {
    this.showPage("community");
    this.pages.community.lists.showGroupPost(new GroupPost({links: {self: "/group_posts/" + id}}));
  },

  showFeedPage: function(c, id) {
    this.showPage("community");
    this.pages.community.lists.showFeedPage(id);
  },

  showFeedSubscribers: function(c, id) {
    this.showPage("community");
    this.pages.community.lists.showFeedSubscribers(id);
  },

  showGroupPage: function(c, id) {
    this.showPage("community");
    this.pages.community.lists.showGroupPage(id);
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
    var tour = new CommonPlace.main.TourModal({
      el: $("#main"),
      account: CommonPlace.account,
      community: CommonPlace.community,
      template: "main_page.tour.modal"
    });
    tour.render();
    tour.welcome();
  },

  showPage: function(name) {
    var page = this.pages[name];
    if (this.currentPage != page) {
      if (this.currentPage) { this.currentPage.unbind(); }
      this.currentPage = page;
      this.currentPage.bind();
      this.currentPage.render();
      //window.scrollTo(0,0);
    }
  },

  bindNewPosts: function() {
    var self = this;
    var community = CommonPlace.community;
    var postlikes = [community.posts, community.events, community.groupPosts, community.announcements, community.transactions];
    _.each(postlikes, function(postlike) {
      postlike.on("sync", function() {
        self.navigate("/", true);
        self.community();
      });
    });
  }

});
