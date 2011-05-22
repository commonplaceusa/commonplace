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
      whatsHappening: new CommonPlace.WhatsHappeningController({community: this.community}),
      profiles: new CommonPlace.ProfileController({community: this.community})
    }

  }

})

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

CommonPlace.GroupInfo = CommonPlace.Info.extend({
  template: "groupinfo",

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
  }
});

CommonPlace.FeedInfo = CommonPlace.Info.extend({
  template: "feedinfo",

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
    "submit form": "submitReply",
    "click a.all-replies" : "showAllReplies",
    "hover div.replies ul li a": "replyHover"
  },

  replies: function() {
    var replies = this.model.get('replies');
    var hasHiddenReplies = false;

    if (_(replies).size() > 3) {
      hasHiddenReplies = true;
      _(replies).chain()
        .first(_(replies).size() - 3)
        .each(function(r) { r.isHidden = true; });
    }

    _(replies).each(function(r) { r.published_at = CommonPlace.formatDate(r.published_at); });

    return {
      repliable_type: this.repliable_type,
      repliable_id: this.model.id,
      hasHiddenReplies: hasHiddenReplies,
      replies: replies,
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
    e.preventDefault();
    var self = this,
        $form = $(e.currentTarget);
    $.post($form.attr("action"), $form.serialize(), 
           function(response) {
             if (response) {
               self.$("div.replies").replaceWith($(window.innerShiv(response, false)));
             }
           });
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
      published_at: CommonPlace.formatDate(this.model.get('published_at')),
      avatar_url: this.model.get("avatar_url"),
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

CommonPlace.EventItem = CommonPlace.PostLikeItem.extend({
  template: "event",
  repliable_type: "Event",

  view: function() {
    return {
      abbrev_month: this.model.get("abbrev_month"),
      day_of_month: this.model.get("day_of_month"),
      author_url: this.model.get('author_url'),
      published_at: CommonPlace.formatDate(this.model.get('published_at')),
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
      author_url: this.model.get('author_url'),
      avatar_url: this.model.get('avatar_url'),
      published_at: CommonPlace.formatDate(this.model.get('published_at')),
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

  view: function() {
    return {
      author_url: this.model.get('author_url'),
      avatar_url: this.model.get('avatar_url'),
      group_url: this.model.get('group_url'),
      published_at: CommonPlace.formatDate(this.model.get('published_at')),
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

  infoUrl: function() {
    return this.model.get('url') + "/info";
  },

  view: function() {
    return {
      id: this.model.get('id'),
      avatar_url: this.model.get('avatar_url'),
      name: this.model.get('name'),
      isSubscribed: _.include(CommonPlace.account.get('feed_subscriptions'), this.model.get('id'))
    };
  }
});

CommonPlace.GroupItem = CommonPlace.Item.extend({
  template: "group",
  className: "group item",

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
  }
});

CommonPlace.Index = Backbone.View.extend({
  tagName: "div",
  
  id: "whats-happening",
  
  events: {
    "click #zones a, #syndicate h3 a" : "send"
  },

  changeZone: function(newZone) {
    this.$('#zones a').removeClass('selected_nav')
      .filter('.' + newZone)
      .addClass('selected_nav');
  },
  
  send: function(e) {
    e.preventDefault();
    window.location.hash = $(e.currentTarget).attr('href');
  },

  render: function() {
    var self = this;
    $(self.el).html(CommonPlace.render("index",
                                       { subnav: this.options.subnav }));

    this.$('#zones a.' + this.options.zone).addClass('selected_nav');

    self.collection.each(function(item) {
      self.$("ul.items")
        .append((new self.options.itemView({model: item})).render().el);
1    });
  }
});

CommonPlace.Wire = CommonPlace.Index.extend({
  render: function() {
    var self = this;
    $(self.el).html(CommonPlace.render("wire", {}));
    
    _(self.model.posts.first(3)).each(function(item) {
      self.$("ul.items.posts")
        .append((new CommonPlace.PostItem({model: item})).render().el);
    });

    _(self.model.events.first(3)).each(function(item) {
      self.$("ul.items.events")
        .append((new CommonPlace.EventItem({model: item})).render().el);
    });

    _(self.model.announcements.first(3)).each(function(item) {
      self.$("ul.items.announcements")
        .append((new CommonPlace.AnnouncementItem({model: item})).render().el);
    });


    _(self.model.group_posts.first(3)).each(function(item) {
      self.$("ul.items.group_posts")
        .append((new CommonPlace.GroupPostItem({model: item})).render().el);
    });
    return self;
  }
});

CommonPlace.SaySomething = Backbone.View.extend({
  tagName: "div",
  id: "say-something",
  
  events: {
    "click nav a": "navigate"
  },
  
  navigate: function(e) {
    e.preventDefault();
    var self = this,
        $link = $(e.currentTarget);
    
    self.$("nav a").removeClass("current")
      .filter("." + $link.attr('class')).addClass("current");


    $.get($link.attr('href'),
          function(response) {
            if (response) {
              self.$("form").replaceWith($(window.innerShiv(response,false)).find("#say-something form"));
              self.$("h2").replaceWith($(window.innerShiv(response, false)).find("#say-something h2"));
      
              $('input.date').datepicker({
                prevText: '&laquo;',
                nextText: '&raquo;',
                showOtherMonths: true,
                defaultDate: null
              });
            }
          });    
  }
});