

var FeedSubResourcesView = CommonPlace.View.extend({
  template: "feed_page/feed-subresources",
  id: "feed-subresources",
  initialize: function(options) {
    this.account = options.account;
    this.feed = options.feed;
    this.announcementsCollection = this.feed.announcements;
    this.eventsCollection = this.feed.events;
    this.subscribersCollection = this.feed.subscribers;
    this.currentTab = options.current || "showAnnouncements";
    this.feed.events.bind("add", function() { this.switchTab("showEvents"); }, this);
    this.feed.announcements.bind("add", function() { this.switchTab("showAnnouncements"); }, this);
    this.feed.subscribers.bind("add", function() { this.switchTab("showSubscribers"); }, this);
  },

  afterRender: function() {
    this[this.currentTab]();
  },

  showAnnouncements: function() {
    var wireView = new AnnouncementWire({
      collection: this.announcementsCollection,
      account: this.account,
      el: this.$(".feed-announcements .wire")
    });
    wireView.render();
  },

  showEvents: function() {
    var wireView = new EventWire({
      collection: this.eventsCollection,
      account: this.account,
      el: this.$(".feed-events .wire")
    });
    wireView.render();
  },

  showSubscribers: function() {
    var wireView = new UserWire({
      collection: this.subscribersCollection,
      account: this.account,
      el: this.$(".feed-subscribers .wire")
    });
    wireView.render();
  },

  tabs: function() {
    return {
      showAnnouncements: this.$(".feed-announcements"),
      showEvents: this.$(".feed-events"),
      showSubscribers: this.$(".feed-subscribers")
    };
  },

  classIfCurrent: function() {
    var self = this;
    return function(text) {
      return text == self.currentTab ? "current" : "";
    };
  },

  switchTab: function(newTab) {
    this.tabs()[this.currentTab].hide();
    this.currentTab = newTab;
    this.tabs()[this.currentTab].show();
    this.render();
  },

  feedName: function() { return this.feed.get('name'); }
});