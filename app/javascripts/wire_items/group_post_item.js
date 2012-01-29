var GroupPostWireItem = WireItem.extend({
  template: "wire_items/post-item",
  tagName: "li",
  className: "wire-item",

  initialize: function(options) {
    var self = this;
    this.model.bind("destroy", function() { self.remove(); });
    this.in_reply_state = true;
  },

  afterRender: function() {
    var repliesView = new RepliesView({ collection: this.model.replies(),
                                        el: this.$(".replies"),
                                        showProfile: this.options.showProfile
                                      });
    repliesView.render();
    this.model.bind("change", this.render, this);
    var self = this;
    repliesView.collection.bind("add", function() { self.render(); });
    this.$(".post-body").truncate({max_length: 450});
    if (this.thanked())
      this.set_thanked(false, this);
  },

  publishedAt: function() {
    return timeAgoInWords(this.model.get("published_at"));
  },

  avatarUrl: function() {
    return this.model.get("avatar_url");
  },

  title: function() {
    return this.model.get("title");
  },

  author: function() {
    return this.model.get("author");
  },

  first_name: function() {
    return this.model.get('first_name');
  },

  body: function() {
      return this.model.get("body");
  },

  numThanks: function() {
      return this.model.get("thanks").length;
  },

  events: {
    "click div.group-post > .author > .person": "messageUser",
    "click .moreBody": "loadMore",
    "mouseenter": "showProfile",
    "mouseenter .group-post": "showProfile",
    "click .editlink": "editGroupPost",
    "click .thank-link": "thank",
    "click .share-link": "share",
    "click .reply-link": "reply",
    "blur": "removeFocus",
    "click .ts-text": "showThanks"
  },

  messageUser: function(e) {
    e && e.preventDefault();
    var user = new User({
      links: {
        self: this.model.get("links").author
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
    var group = new Group({
      links: { self: this.model.link("group") }
    });
    this.options.showProfile(group);
  },

  canEdit: function() { return CommonPlace.account.canEditGroupPost(this.model); },

  editGroupPost: function(e) {
    e && e.preventDefault();
    var formview = new PostFormView({
      model: this.model,
      template: "shared/group-post-edit-form"
    });
    formview.render();
  },
  
  group: function() { return this.model.get("group"); },
  
  groupUrl: function() { return this.model.get("group_url"); },
});
