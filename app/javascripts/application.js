//= require json2
//= require showdown
//= require jquery
//= require jquery-ui
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

//= require config
//= require feature_switches

//= require views
//= require models
//= require info_boxes
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
      account: new AccountPage({ el: $("#main") })
    }; 

    _.invoke(this.pages, "unbind");
  },

  routes: {
    "/faq": "faq",
    "/invite": "invite",
    "/discount": "discount",

    "/": "community",
    "": "community",
    "/list/:tab": "communityWire",
    "/share/:tab": "communityPostBox",

    "/show/posts/:id": "showPost",
    "/show/events/:id": "showEvent",
    "/show/group_posts/:id": "showGroupPost",
    "/show/announcements/:id": "showAnnouncement",

    "/message/users/:id": "messageUser",
    "/message/feeds/:id": "messageFeed",

    "/inbox": "inbox",
    "/outbox": "outbox",
    "/feed_inbox": "feed_inbox",

    "/account": "account",
    
    "/tour": "tour"
  },


  faq: function() { this.showPage("faq"); },

  invite: function() { this.showPage("invite"); },

  discount: function() { this.showPage("discount"); },

  community: function() { 
    this.showPage("community"); 
    this.pages.community.lists.switchTab("landing");
  },

  communityWire: function(tab) {
    this.showPage("community");
    this.pages.community.lists.switchTab(tab);
  },

  communityPostBox: function(tab) {
    this.showPage("community");
    this.pages.community.postBox.switchTab(tab);
  },

  showPost: function(id) {
    this.showPage("community");
    this.pages.community.lists.showPost(new Post({links: {self: "/posts/" + id}}));
  },

  showEvent: function(id) {
    this.showPage("community");
    this.pages.community.lists.showEvent(new Event({links: {self: "/events/" + id }}));
  },

  showGroupPost: function(id) {
    this.showPage("community");
    this.pages.community.lists.showGroupPost(new GroupPost({links: {self: "/group_posts/" + id}}));
  },

  showAnnouncement: function(id) {
    this.showPage("community");
    this.pages.community.lists.showAnnouncement(new Announcement({links: {self: "/announcements/" + id}}));
  },

  messageUser: function(id) {
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

  messageFeed: function(id) {
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

  inbox: function() { this.showPage("inbox"); },

  outbox: function() { this.showPage("outbox"); },

  feed_inbox: function() { this.showPage("feed_inbox"); },

  account: function() { this.showPage("account"); },

  tour: function() {
    this.showPage("community");
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
  }
  
});
