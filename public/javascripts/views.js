var CommonPlace = CommonPlace || {};

CommonPlace.render = function(name, params) {
  return Mustache.to_html(
    CommonPlace.templates[name],
    _.extend({auth_token: CommonPlace.auth_token,
              account_avatar_url: CommonPlace.account.get('avatar_url')},
             params),
    CommonPlace.templates);
};

CommonPlace.MainPage = Backbone.View.extend({
  
  initialize: function(options) {
    this.community = this.options.community;
    this.account = this.options.account;
    this.controllers = {
      saySomething: new CommonPlace.SaySomethingController({}),
      whatsHappening: new CommonPlace.WhatsHappeningController({community: this.community}),
      profiles: new CommonPlace.ProfileController({community: this.community})
    };
  }

});

CommonPlace.Info = Backbone.View.extend({
  tagName: "div",
  id: "community-profiles",
  render: function() {
    this.el.html(CommonPlace.render(this.template || this.options.template,
                                    this.model.toJSON()));
    setInfoBoxPosition();
    return this;
  }
});

CommonPlace.EventInfo = CommonPlace.Info.extend({
  template: "eventinfo",

  render: function() {
    this.el.html(CommonPlace.render(this.template,
                                    this.view()));
    setInfoBoxPosition();
    return this;
  },

  view: function() {
    var params = this.model.toJSON() || {};
    params.abbrev_month = this.model.abbrev_month_name();
    params.day_of_month = this.model.day_of_month();
    return params;
  }
});

CommonPlace.GroupInfo = CommonPlace.Info.extend({
  template: "groupinfo",

  events: {
    "click a.new_subscription": "subscribe",
    "click a.unsubscribe": "unsubscribe"
  },

  initialize: function(options) {
    var self = this ;
    CommonPlace.account.bind("change:group_subscriptions",
                             function() { self.render(); });
  },

  render: function() {
    this.el.html(CommonPlace.render(this.template || this.options.template,
                                    this.view()));
    setInfoBoxPosition();
    return this;
  },

  view: function() {
    return { 
      id: this.model.get('id'),
      url: this.model.get('url'),
      avatar_url: this.model.get('avatar_url'),
      name: this.model.get('name'),
      about: this.model.get('about'),
      isSubscribed: _.include(CommonPlace.account.get('group_subscriptions'), this.model.get('id'))
    };
  },

  subscribe: function(e) {
    e.preventDefault();
    CommonPlace.account.subscribeToGroup(this.model.id);
  },
  
  unsubscribe: function(e) {
    e.preventDefault();
    CommonPlace.account.unsubscribeFromGroup(this.model.id);
  }
});

CommonPlace.FeedInfo = CommonPlace.Info.extend({
  template: "feedinfo",

  events: {
    "click a.new_subscription": "subscribe",
    "click a.unsubscribe": "unsubscribe"
  },

  initialize: function(options) {
    var self = this;
    CommonPlace.account.bind("change:feed_subscriptions",
                             function() { self.render(); });
  },

  render: function() {
    this.el.html(CommonPlace.render(this.template || this.options.template,
                                    this.view()));
    setInfoBoxPosition();
    return this;
  },

  view: function() {
    return { 
      id: this.model.get('id'),
      url: this.model.get('url'),
      avatar_url: this.model.get('avatar_url'),
      name: this.model.get('name'),
      about: this.model.get('about'),
      tags: this.model.get('tags'),
      website: this.model.get('website'),
      phone: this.model.get('phone'),
      address: this.model.get('address'),
      isSubscribed: _.include(CommonPlace.account.get('feed_subscriptions'), this.model.get('id'))
    };
  },

  subscribe: function(e) {
    e.preventDefault();
    CommonPlace.account.subscribeToFeed(this.model.id);
  },
  
  unsubscribe: function(e) {
    e.preventDefault();
    CommonPlace.account.unsubscribeFromFeed(this.model.id);
  }
});

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
    "hover div.replies ul li a": "replyHover",
    "click .toggle-actions": "toggleActions"
  },
  toggleActions: function() { this.$(".actions").toggle(); },
  replies: function() {
    var repliesView = this.model.replies.toJSON(),
        numHiddenReplies = _(repliesView).size() - 3;

    _(repliesView).each(function(reply, index) { 
      reply.published = CommonPlace.timeAgoInWords(reply.published_at); 
      reply.isHidden = index < numHiddenReplies;
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
    window.location.hash = $(e.currentTarget).attr('href') + "/info";
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
      body: this.model.get('body'),
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
      body: this.model.get('body')
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
      body: this.model.get('body')
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
      body: this.model.get('body')
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

CommonPlace.Index = Backbone.View.extend({
  tagName: "div",
  
  id: "whats-happening",
  
  changeZone: function(newZone) {
    this.$('#zones a').removeClass('selected_nav').
      filter('.' + newZone).
      addClass('selected_nav');
  },

  render: function() {
    var self = this;
    $(self.el).html(CommonPlace.render("index",
                                       { subnav: this.options.subnav }));

    this.$('#zones a.' + this.options.zone).addClass('selected_nav');

    self.collection.each(function(item) {
      self.$("ul.items").append((new self.options.itemView({model: item})).render().el);
    });
  }
});

CommonPlace.Wire = CommonPlace.Index.extend({
  render: function() {
    var self = this;
    $(self.el).html(CommonPlace.render("wire", {}));
    
    _(self.model.posts.first(3)).each(function(item) {
      self.$("ul.items.posts").append((new CommonPlace.PostItem({model: item})).render().el);
    });

    _(self.model.events.first(3)).each(function(item) {
      self.$("ul.items.events").append((new CommonPlace.EventItem({model: item})).render().el);
    });

    _(self.model.announcements.first(3)).each(function(item) {
      self.$("ul.items.announcements").append((new CommonPlace.AnnouncementItem({model: item})).render().el);
    });


    _(self.model.group_posts.first(3)).each(function(item) {
      self.$("ul.items.group_posts").append((new CommonPlace.GroupPostItem({model: item})).render().el);
    });
    return self;
  }
});

CommonPlace.SaySomething = Backbone.View.extend({
  tagName: "div",
  id: "say-something",
  
  events: {
    "submit form.post": "submitPost"
  },
  
  render: function() {
    var view = this[this.template]();
    view[this.template] = true ;
    $(this.el).html(CommonPlace.render(this.template, view));
    $("input.date").datepicker();
  },

  submitPost: function(e) {
    e.preventDefault();
    var self = this;
    var $form = this.$("form");
    $("input.create", $form).replaceWith("<img src=\"/images/loading.gif\">");
    CommonPlace.community.posts.create({ 
      title: $("input#post_subject",$form).val(),
      body: $("textarea#post_body",$form).val() 
    }, { success: function() {
      window.location.hash = "/posts";
      Backbone.history.checkUrl();
      window.location.hash = "/posts/new";
      Backbone.history.checkUrl();
    },
         error: function() { self.render(); }
       });
  },

  submitAnnouncement: function(e) {
    e.preventDefault();
    var $form = this.$("form"),
    owner_match = $("select#announcement_owner", $form).val().match(/([a-z_]+)_(\d+)/);
    
    CommonPlace.community.announcements.create({
      title: $("input#announcement_subject", $form).val(),
      body: $("textarea#announcement_body", $form).val(),
      style: "publicity",
      feed: owner_match[1] == "feed" ? owner_match[2] : null
    }, { success: function() {
      window.location.hash = "/announcements";
      Backbone.history.checkUrl();
      window.location.hash = "/announcements/new";
      Backbone.history.checkUrl();
    } });
  },

  post_form: function() { return ({});},

  event_form: function() { 
    var view = { 
      owners: _(CommonPlace.account.get('accounts')).map(
        function(a) {
          return { name: a.name, value: a.uid };
        })
    };
    view.owners[0].selected = "selected";
    return view;
  },

  announcement_form: function() { 
    var view = { 
      owners: _(CommonPlace.account.get('accounts')).map(
        function(a) {
          return { name: a.name, value: a.uid };
        })
    };
    view.owners[0].selected = "selected";
    return view;
  },

  group_post_form: function() {
    var view = { 
      groups: CommonPlace.community.groups.map(function(g) {
        return { id: g.id, name: g.get('name') };
      })
    };
    view.groups[0].selected = "selected";
    return view;
  }
  
});


