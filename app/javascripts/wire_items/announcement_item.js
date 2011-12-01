var AnnouncementWireItem = WireItem.extend({
  template: "wire_items/announcement-item",
  tagName: "li",
  className: "wire-item",

  initialize: function(options) {
    this.account = CommonPlace.account;
    var self = this;
    this.model.bind("destroy", function() { self.remove(); });
  },

  afterRender: function() {
    var repliesView = new RepliesView({ collection: this.model.replies(),
                                        el: this.$(".replies"),
                                        account: this.account
                                      });
    repliesView.render();
    this.model.bind("change", this.render, this);
    this.$(".announcement-body").truncate({max_length: 450});
  },
  
  publishedAt: function() {
    return timeAgoInWords(this.model.get('published_at'));
  },

  avatarUrl: function() { return this.model.get('avatar_url'); },
  
  url: function() { return this.model.get('url'); },

  title: function() { return this.model.get('title'); },
  
  author: function() { return this.model.get('author'); },
  
  body: function() {
    return this.model.get("body");
  },
  
  events: {
    "click .editlink": "editAnnouncement",
    "mouseenter": "showProfile",
    "click .announcement > .author": "messageUser"
  },

  editAnnouncement: function(e) {
    e && e.preventDefault();
    var formview = new PostFormView({
      model: this.model,
      template: "shared/announcement-edit-form"
    });
    formview.render();
  },

  canEdit: function() {
    return this.account.canEditAnnouncement(this.model);
  },

  isMore: function() {
    return !this.allwords;
  },

  loadMore: function(e) {
    e.preventDefault();
    this.allwords = true;
    this.render();
  },

  showProfile: function(e) {
    window.infoBox.showProfile(this.model.author());
  },
  
  isFeed: function() { return this.model.get("owner_type") == "Feed"; },
  
  feedUrl: function() { return this.model.get("feed_url"); },
  
  messageUser: function(e) {
    if (!this.isFeed()) {
      e && e.preventDefault();
      var user = new User({
        links: {
          self: this.model.get("user_url")
        }
      });
      user.fetch({
        success: function() {
          var formview = new MessageFormView({
            model: new Message({messagable: user})
          });
          formview.render();
        }
      });
    }
  }
    
});
