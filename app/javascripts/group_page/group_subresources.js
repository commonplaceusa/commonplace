var GroupSubresourcesView = CommonPlace.View.extend({
  template: "group_page/subresources",
  id: "group-subresources",
  
  initialize: function(options) {
    var self = this;
    this.account = options.account;
    this.group = options.model;
    this.groupPostsCollection = this.group.posts;
    this.groupMembersCollection = this.group.members;
    this.groupAnnouncementsCollection = this.group.announcements;
    this.groupEventsCollection = this.group.events;
    this.currentTab = options.current || "showGroupPosts";
    this.group.posts.bind("add", function() { self.switchTab("showGroupPosts"); }, this);
    this.group.members.bind("add", function() { self.switchTab("showGroupMembers"); }, this);
    this.group.announcements.bind("add", function() { self.switchTab("showAnnouncements"); }, this);
    this.group.events.bind("add", function() { self.switchTab("showEvents"); }, this);
  },

  afterRender: function() {
    this[this.currentTab]();
  },

  showGroupPosts: function() {
    var account = this.account;
    var wireView = new PaginatingWire({
      collection: this.groupPostsCollection,
      account: this.account,
      el: this.$(".group-posts .wire"),
      emptyMessage: "No posts here yet",
      modelToView: function(model) {
        return new GroupPostWireItem({ model: model, account: account });
      }
    });
    wireView.render();
  },

  showGroupMembers: function() {
    var account = this.account;
    var wireView = new PaginatingWire({
      collection: this.groupMembersCollection,
      account: this.account,
      el: this.$(".group-members .wire"),
      emptyMessage: "No members yet",
      modelToView: function(model) {
        return new UserWireItem({ model: model, account: account });
      }
    });
    wireView.render();
  },

  showAnnouncements: function() {
    var account = this.account;
    var wireView = new PaginatingWire({
      collection: this.groupAnnouncementsCollection,
      account: this.account,
      el: this.$(".group-announcements .wire"),
      emptyMessage: "No announcements here yet",
      modelToView: function(model) {
        return new AnnouncementWireItem({ model: model, account: account });
      }
    });
    wireView.render();
  },

  showEvents: function() {
    var account = this.account;
    var wireView = new PaginatingWire({
      collection: this.groupEventsCollection,
      account: this.account,
      el: this.$(".group-events .wire"),
      emptyMessage: "No events here yet",
      modelToView: function(model) {
        return new EventWireItem({ model: model, account: account });
      }
    });
    wireView.render();
  },

  tabs: function() {
    return {
      showGroupPosts: this.$(".group-posts"),
      showGroupMembers: this.$(".group-members"),
      showAnnouncements: this.$(".group-announcements"),
      showEvents: this.$(".group-events")
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
  }

});
