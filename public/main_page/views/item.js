CommonPlace.renderBody = function(text) {
  console.log(text);
  return (new Showdown.converter()).makeHtml(window.linkify(text));
};


CommonPlace.Item = Backbone.View.extend({
  tagName: "li",
  className: "item",

  events: { "mouseenter": "showInfo" },
  
  render: function() {
    var self = this;
    $(self.el).html(CommonPlace.render(self.template,
                                       self.view()));
    return self;
  },
  
  showInfo: function() { 
    window.location.hash = this.infoUrl();
    return this; 
  }
});

CommonPlace.PostLikeItem = CommonPlace.Item.extend({

  events: {
    "click a.show-reply-form": "showReplyForm",
    "mouseenter": "showInfo",
    "submit form.new_reply": "submitReply",
    "click a.all-replies" : "showAllReplies",
    "hover div.replies ul li": "replyHover",
    "click .toggle-actions": "toggleActions"
  },
  toggleActions: function() { this.$(".actions").toggle(); },
  replies: function() {
    var repliesView = this.model.replies.toJSON(),
        numHiddenReplies = _(repliesView).size() - 3;

    _(repliesView).each(function(reply, index) { 
      reply.published = CommonPlace.timeAgoInWords(reply.published_at); 
      reply.isHidden = index < numHiddenReplies;
      reply.body = window.linkify(reply.body);
    });

    return {
      repliable_type: this.repliable_type,
      repliable_id: this.model.id,
      hasHiddenReplies: numHiddenReplies > 0,
      replies: repliesView
    };
  },

  render: function() {
    $(this.el).html(CommonPlace.render(this.template,
                                       _(this.view()).extend(this.replies())));

    return this;
  },
  
  showReplyForm: function(e) {
    e.preventDefault();
    $(e.currentTarget).hide();
    this.$("div.replies").show();
  },
  showAllReplies: function(e) {
    e.preventDefault();
    this.$("a.all-replies").hide();
    this.$("div.replies li").show();
  },

  submitReply: function(e) {
    var self = this;
    e.preventDefault();
    this.$("input[type=submit]").replaceWith("<img src=\"/images/loading.gif\">");
    this.model.replies.create({body: $("textarea[name='reply[body]']", e.currentTarget).val()},
                              {success: function() {self.render(); },
                               error: function() {self.render(); } });
  },

  replyHover: function(e) {
    window.location.hash = $(e.currentTarget).attr('data-url') + "/info";
  }

});

CommonPlace.PostItem = CommonPlace.PostLikeItem.extend({
  template: "post",
  repliable_type: "Post",

  
  view: function() {
    return {
      published_at: CommonPlace.timeAgoInWords(this.model.get('published_at')),
      avatar_url: this.model.get("avatar_url"),
      reply_count: this.model.replies.size(),
      url: this.model.get('url'),
      title: this.model.get('title'),
      author: this.model.get('author'),
      body: CommonPlace.renderBody(this.model.get('body')),
      id: this.model.get('id'),
      any_available_actions: CommonPlace.account.can_notify_all(this.model) || 
        CommonPlace.account.can_delete(this.model),
      can_notify_all: CommonPlace.account.can_notify_all(this.model),
      can_delete: CommonPlace.account.can_delete(this.model)
    };
  },

  infoUrl: function() {
    return this.model.get('author_url') + "/info";
  }

});

CommonPlace.EventItem = CommonPlace.PostLikeItem.extend({
  template: "event",
  repliable_type: "Event",

  view: function() {
    return {
      id: this.model.get('id'),
      occurs_in: CommonPlace.timeAgoInWords(this.model.get('occurs_at')),
      abbrev_month: this.model.abbrev_month_name(),
      day_of_month: this.model.day_of_month(),
      author_url: this.model.get('author_url'),
      published_at: CommonPlace.timeAgoInWords(this.model.get('published_at')),
      reply_count: _(this.model.get('replies')).size(),
      url: this.model.get('url'),
      title: this.model.get('title'),
      author: this.model.get('author'),
      body: CommonPlace.renderBody(this.model.get('body'))
    };
  },

  infoUrl: function() {
    return this.model.get('url') + "/info";
  }
});

CommonPlace.AnnouncementItem = CommonPlace.PostLikeItem.extend({
  template: "announcement",
  repliable_type: "Announcement",
  
  view: function() {
    return {
      id: this.model.get('id'),
      author_url: this.model.get('author_url'),
      avatar_url: this.model.get('avatar_url'),
      published_at: CommonPlace.timeAgoInWords(this.model.get('published_at')),
      reply_count: _(this.model.get('replies')).size(),
      url: this.model.get('url'),
      title: this.model.get('title'),
      author: this.model.get('author'),
      body: CommonPlace.renderBody(this.model.get('body'))
    };
  },

  infoUrl: function() {
    return this.model.get('author_url') + "/info";
  }
});

CommonPlace.GroupPostItem = CommonPlace.PostLikeItem.extend({
  template: "group_post",
  repliable_type: "GroupPost",
  view: function() {
    return {
      id: this.model.get('id'),
      author_url: this.model.get('author_url'),
      avatar_url: this.model.get('avatar_url'),
      group_url: this.model.get('group_url'),
      published_at: CommonPlace.timeAgoInWords(this.model.get('published_at')),
      reply_count: _(this.model.get('replies')).size(),
      url: this.model.get('url'),
      title: this.model.get('title'),
      author: this.model.get('author'),
      body: CommonPlace.renderBody(this.model.get('body'))
    };
  },

  infoUrl: function() {
    return this.model.get('group_url') + "/info";
  }
});

CommonPlace.UserItem = CommonPlace.Item.extend({
  template: "user",
  infoUrl: function() {
    return this.model.get('url') + "/info";
  },
  
  view: function() {
    return {
      id: this.model.get('id'),
      url: this.model.get('url'),
      name: this.model.get('name'),
      avatar_url: this.model.get('avatar_url') 
    };
  }
});

CommonPlace.FeedItem = CommonPlace.Item.extend({
  template: "feed",
  className: "feed item",

  events: { 
    "mouseenter": "showInfo",
    "click a.new_subscription": "subscribe"
  },

  infoUrl: function() {
    return this.model.get('url') + "/info";
  },
  
  initialize: function(options) {
    var self = this;
    CommonPlace.account.bind("change:feed_subscriptions", 
                             function() { self.render(); });
  },

  view: function() {
    return {
      id: this.model.get('id'),
      avatar_url: this.model.get('avatar_url'),
      name: this.model.get('name'),
      isSubscribed: _.include(CommonPlace.account.get('feed_subscriptions'), this.model.get('id'))
    };
  },

  subscribe: function(e) {
    e.preventDefault();
    CommonPlace.account.subscribeToFeed(this.model.id);
  }
});

CommonPlace.GroupItem = CommonPlace.Item.extend({
  template: "group",
  className: "group item",

  events: {
    "mouseenter": "showInfo",
    "click a.new_subscription": "subscribe"
  },

  initialize: function(options) {
    var self = this;
    CommonPlace.account.bind("change:group_subscriptions",
                             function() { self.render(); });
  },

  infoUrl: function() {
    return this.model.get('url') + "/info";
  },

  view: function() {
    return {
      id: this.model.get('id'),
      url: this.model.get('url'),
      avatar_url: this.model.get('avatar_url'),
      name: this.model.get('name'),
      isSubscribed: _.include(CommonPlace.account.get('group_subscriptions'), this.model.get('id'))
    };
  },

  subscribe: function(e) {
    e.preventDefault();
    CommonPlace.account.subscribeToGroup(this.model.id);
  }

});
