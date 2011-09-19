var WireView = CommonPlace.View.extend({
  className: "wire",
  template: "shared/wire",

  events: {
    "click a.more": "showMore"
  },

  initialize: function(options) { 
    this.account = options.account;
  },

  aroundRender: function(render) {
    var self = this;
    this.fetchCurrentPage(function() {
      render();
    });
  },

  afterRender: function() { this.appendCurrentPage(); },

  modelToView: function() { 
    throw new Error("This is an abstract class, use a child of this class");
  },

  fetchCurrentPage: function(callback) {
    this.collection.fetch({
      data: { limit: this.perPage(), page: this.currentPage() },
      success: callback
    });
  },

  appendCurrentPage: function() {
    var self = this;
    var $ul = this.$("ul.wire-list");
    this.collection.each(function(model) {
      $ul.append(self.modelToView(model).render().el);
    });
  },

  areMore: function() {
    return !(this.collection.length < this.perPage());
  },

  isEmpty: function() {
    return this.collection.isEmpty();
  },

  emptyMessage: function() {
    throw new Error("This is an abstract class, use a child of this class");
  },
    
  showMore: function(e) {
    var self = this;
    e.preventDefault();
    this.nextPage();
    this.fetchCurrentPage(function() { self.appendCurrentPage(); });
  },

  currentPage: function() {
    return (this._currentPage || this.options.currentPage || 0);
  },

  perPage: function() {
    return (this.options.perPage || 10);
  },

  nextPage: function() {
    this._currentPage = (this._currentPage || this.options.currentPage || 0) + 1;
  }
});

var WireItemView = CommonPlace.View.extend({
  showInfoBox: function() {
    var $infoBox = $("#info-box");
    if ($infoBox.size() === 1) {
      this.getInfoBox(function(infoBox) {
        infoBox.render();
        $infoBox.replaceWith(infoBox.el);
        infoBox.setPosition();
      });
    }
  }
});

var PostWireView = WireView.extend({
  initialize: function(options) {
    this.account = options.account;
  },

  modelToView: function(model) {
    return new PostItemView({
      model: model,
      account: this.account
    });
  },

  emptyMessage: "No posts here yet"
});

var EventWireView = WireView.extend({
  initialize: function(options) {
    this.account = options.account;
  },

  modelToView: function(model) {
    return new EventItemView({
      model: model,
      account: this.account
    });
  },

  emptyMessage: "No events here yet"
});

var AnnouncementWireView = WireView.extend({
  initialize: function(options) {
    this.account = options.account;
  },

  modelToView: function(model) {
    return new AnnouncementItemView({
      model: model,
      account: this.account
    });
  },

  emptyMessage: "No announcements here yet"
});

var UserWireView = WireView.extend({
  modelToView: function(model) {
    return new UserItemView({model: model, account: this.account});
  },

  emptyMessage: "Nobody here yet"
});

var FeedWireView = WireView.extend({
  modelToView: function(model) {
    return new FeedItemView({model: model, account: this.options.account});
  },

  emptyMessage: "No feeds here yet"
});

var GroupWireView = WireView.extend({
  modelToView: function(model) {
    return new GroupItemView({model: model, account: this.options.account});
  },

  emptyMessage: "No groups here yet"
});

var UserItemView = WireItemView.extend({
  template: "shared/user-item",
  tagName: "li",
  className: "wire-item",
  
  initialize: function(options) {},

  afterRender: function() {
    this.model.bind("change", this.render, this);
  },

  avatarUrl: function() {
    return this.model.get("avatar_url");
  },

  firstname: function() {
    return this.model.get("first_name");
  },

  lastname: function() {
    return this.model.get("last_name");
  },

  events: {
    "click button": "messageUser",
    "mouseenter": "showInfoBox"
  },

  messageUser: function(e) {
    e && e.preventDefault();
    var formview = new MessageFormView({
      model: new Message({messagable: this.model})
    });
    formview.render();
  },

  getInfoBox: function(callback) {
    callback(new UserInfoBox({ model: this.model, account: this.options.account }));
  }

});

var FeedItemView = WireItemView.extend({
  template: "shared/feed-item",
  tagName: "li",
  className: "wire-item",

  initialize: function() {
    this.options.account.bind("change", this.render, this);
  },

  events: {
    "mouseenter": "showInfoBox",
    "click button.subscribe": "subscribe",
    "click button.unsubscribe": "unsubscribe"
  },

  avatarUrl: function() {
    return this.model.get("avatar_url");
  },

  name: function() {
    return this.model.get("name");
  },

  getInfoBox: function(callback) {
    callback(new FeedInfoBox({ model: this.model, account: this.options.account }));
  },

  subscribe: function() { this.options.account.subscribeToFeed(this.model); },

  unsubscribe: function() { this.options.account.unsubscribeFromFeed(this.model); },

  isSubscribed: function() { return this.options.account.isSubscribedToFeed(this.model); }

});

var GroupItemView = WireItemView.extend({
  template: "shared/feed-item",
  tagName: "li",
  className: "wire-item",

  initialize: function() {
    this.options.account.bind("change", this.render, this);
  },

  events: {
    "mouseenter": "showInfoBox",
    "click button.subscribe": "subscribe",
    "click button.unsubscribe": "unsubscribe"
  },

  avatarUrl: function() {
    return this.model.get("avatar_url");
  },

  name: function() {
    return this.model.get("name");
  },

  getInfoBox: function(callback) {
    callback(new GroupInfoBox({model: this.model, account: this.options.account}));
  },

  subscribe: function() { this.options.account.subscribeToGroup(this.model); },

  unsubscribe: function() { this.options.account.unsubscribeFromGroup(this.model); },

  isSubscribed: function() { return this.options.account.isSubscribedToGroup(this.model); }


});

var GroupPostWireView = WireView.extend({
  modelToView: function(model) {
    return new GroupPostItemView({model: model, account: this.options.account});
  },

  emptyMessage: "No posts here yet"
});

var EventItemView = WireItemView.extend({
  template: "shared/event-item",
  tagName: "li",
  className: "wire-item",

  initialize: function(options) {
    this.account = options.account;
    this.shortbody = this.model.get("body").match(/\b([\w]+[\W]+){60}/);
    this.allwords = (this.shortbody == null);
  },

  afterRender: function() {
    var repliesView = new RepliesView({ collection: this.model.replies(),
                                        el: this.$(".replies"),
                                        account: this.account
                                      });
    repliesView.render();
    this.model.bind("change", this.render, this);
  },

  short_month_name: function() { 
    var m = this.model.get("occurs_on").match(/(\d{4})-(\d{2})-(\d{2})/);
    return this.monthAbbrevs[m[2] - 1];
  },

  day_of_month: function() { 
    var m = this.model.get("occurs_on").match(/(\d{4})-(\d{2})-(\d{2})/);
    return m[3]; 
  },

  publishedAt: function() { return timeAgoInWords(this.model.get('published_at')); },

  replyCount: function() { return this.model.get('replies').length; },

  title: function() { return this.model.get('title'); },

  author: function() { return this.model.get('author'); },
  
  body: function() {
    if (!this.allwords) {
      return this.shortbody[0];
    } else {
      return this.model.get("body");
    }
  },

  monthAbbrevs: ["Jan", "Feb", "Mar", "Apr", "May", "Jun",
                 "Jul", "Aug", "Sept", "Oct", "Nov", "Dec"],

  events: {
    "click .editlink": "editEvent",
    "click .moreBody": "loadMore",
    "mouseenter": "showInfoBox"
  },

  editEvent: function(e) {
    e && e.preventDefault();
    var formview = new EventFormView({
      model: this.model,
      template: "shared/event-edit-form"
    });
    formview.render();
  },

  isOwner: function() {
    return (_.indexOf(this.account.get("events"), this.model.get("id"))>=0);
  },

  isMore: function() {
    return !this.allwords;
  },

  loadMore: function(e) {
    e.preventDefault();
    this.allwords = true;
    this.render();
  },

  getInfoBox: function(callback) {
    callback(new EventInfoBox({ model: this.model, account: this.account }));
  }

});

var AnnouncementItemView = WireItemView.extend({
  template: "shared/announcement-item",
  tagName: "li",
  className: "wire-item",

  initialize: function(options) {
    this.account = options.account;
    this.shortbody = this.model.get("body").match(/\b([\w]+[\W]+){60}/);
    this.allwords = (this.shortbody == null);
  },

  afterRender: function() {
    var repliesView = new RepliesView({ collection: this.model.replies(),
                                        el: this.$(".replies"),
                                        account: this.account
                                      });
    repliesView.render();
    this.model.bind("change", this.render, this);
  },
  
  publishedAt: function() {
    return timeAgoInWords(this.model.get('published_at'));
  },

  replyCount: function() {
    var num = this.model.get('replies').length;
    return (num == 1 ? "1 reply" : num + " replies");
  },

  avatarUrl: function() { return this.model.get('avatar_url'); },
  
  url: function() { return this.model.get('url'); },

  title: function() { return this.model.get('title'); },
  
  author: function() { return this.model.get('author'); },
  
  body: function() {
    if (!this.allwords) {
      return this.shortbody[0];
    } else {
      return this.model.get("body");
    }
  },
  
  events: {
    "click .editlink": "editAnnouncement",
    "click .moreBody": "loadMore",
    "mouseenter": "showInfoBox"
  },

  editAnnouncement: function(e) {
    e && e.preventDefault();
    var formview = new AnnouncementFormView({
      model: this.model,
      template: "shared/announcement-edit-form"
    });
    formview.render();
  },

  isOwner: function() {
    return (_.indexOf(this.account.get("announcements"), this.model.get("id"))>=0);
  },

  isMore: function() {
    return !this.allwords;
  },

  loadMore: function(e) {
    e.preventDefault();
    this.allwords = true;
    this.render();
  },
  
  getInfoBox: function(callback) {
    var self = this;
    this.model.author(function(author) {
      if (self.model.get('owner_type') == "Feed") {
        callback(new FeedInfoBox({ model: author, account: self.account }));
      } else {
        callback(new UserInfoBox({ model: author, account: self.account }));
      }
    });
  }
    
});

var GroupPostItemView = WireItemView.extend({
  template: "shared/post-item",
  tagName: "li",
  className: "wire-item",

  initialize: function(options) {
    this.account = options.account;
    this.shortbody = this.model.get("body").match(/\b([\w]+[\W]+){60}/);
    this.allwords = (this.shortbody == null);
  },

  afterRender: function() {
    var repliesView = new RepliesView({ collection: this.model.replies(),
                                        el: this.$(".replies"),
                                        account: this.account
                                      });
    repliesView.render();
    this.model.bind("change", this.render, this);
    var self = this;
    repliesView.collection.bind("add", function() { self.render(); });
  },

  replyCount: function() {
    var num = this.model.replies().length;
    return (num == 1 ? "1 reply" : num + " replies");
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

  body: function() {
    if (!this.allwords) {
      return this.shortbody[0];
    } else {
      return this.model.get("body");
    }
  },

  events: {
    "click .author": "messageUser",
    "click .moreBody": "loadMore",
    "mouseenter": "showInfoBox"
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
  
  getInfoBox: function(callback) {
    var account = this.account;
    this.model.group(function(group) {
      callback(new GroupInfoBox({ model: group, account: account }));
    });
  }

});

var PostItemView = WireItemView.extend({
  template: "shared/post-item",
  tagName: "li",
  className: "wire-item",

  initialize: function(options) {
    this.account = options.account;
    this.shortbody = this.model.get("body").match(/\b([\w]+[\W]+){60}/);
    this.allwords = (this.shortbody == null);
  },

  afterRender: function() {
    var repliesView = new RepliesView({ collection: this.model.replies(),
                                        el: this.$(".replies"),
                                        account: this.account
                                      });
    repliesView.render();
    this.model.bind("change", this.render, this);
    var self = this;
    repliesView.collection.bind("add", function() { self.render(); });
  },

  replyCount: function() {
    var num = this.model.replies().length;
    return (num == 1 ? "1 reply" : num + " replies");
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

  body: function() {
    if (!this.allwords) {
      return this.shortbody[0];
    } else {
      return this.model.get("body");
    }
  },

  events: {
    "click .author": "messageUser",
    "click .moreBody": "loadMore",
    "mouseenter": "showInfoBox"
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
  
  getInfoBox: function(callback) {
    var account = this.account;
    this.model.user(function(user) {
      callback(new UserInfoBox({ model: user, account: account }));
    });
  }

});




var FormView = CommonPlace.View.extend({
  initialize: function(options) {
    this.template = (this.options.template || this.template);
    this.modal = new ModalView({form: this.el});
  },

  afterRender: function() {
    this.modal.render();
  },

  events: {
    "click form a.cancel": "exit",
    "submit form": "send"
  },

  send: function(e) {
    e.preventDefault();
    this.save();
    this.exit();
  },

  exit: function(e) {
    e && e.preventDefault();
    this.modal.exit();
  }
});

var MessageFormView = FormView.extend({
  template: "shared/message-form",

  save: function() {
    this.model.save({
      subject: this.$("[name=subject]").val(),
      body: this.$("[name=body]").val()
    });
  },

  name: function() {
    return this.model.name();
  }
});

var AnnouncementFormView = FormView.extend({
  save: function() {
    this.model.save({
      title: this.$("[name=title]").val(),
      body: this.$("[name=body]").val()
    });
  },

  title: function() {
    return this.model.get("title");
  },

  body: function() {
    return this.model.get("body");
  }
});

var EventFormView = FormView.extend({
  afterRender: function() {
    this.modal.render();
    $("input.date", this.el).datepicker({dateFormat: 'yy-mm-dd'});
  },

  save: function() {
    this.model.save({
      title: this.$("[name=title]").val(),
      body: this.$("[name=body]").val(),
      occurs_at: this.$("[name=date]").val(),
      starts_at: this.$("[name=start]").val(),
      ends_at: this.$("[name=end]").val(),
      venue: this.$("[name=venue]").val(),
      address: this.$("[name=address]").val()
    });
  },

  title: function() {
    return this.model.get("title");
  },

  body: function() {
    return this.model.get("body");
  },

  date: function() {
    return this.model.get("occurs_at").split("T")[0];
  },

  venue: function() {
    return this.model.get("venue");
  },

  address: function() {
    return this.model.get("address");
  },

  time_values: function() {
    var start_value = this.model.get("starts_at").replace(" ", "");
    var end_value = this.model.get("ends_at").replace(" ", "");
    var list = _.flatten(_.map(["AM", "PM"],
      function(half) {
        return  _.map(_.range(1,13),
        function(hour) {
          return _.map(["00", "30"],
          function(minute) {
            return String(hour) + ":" + minute + " " + half;
          });
        });
      })
    );
    var result = new Array();
    _.each(list, function(time) {
      var obj = {
        ".": time,
        "is_start": (time.replace(" ","").toLowerCase() == start_value),
        "is_end": (time.replace(" ","").toLowerCase() == end_value)
      };
      result.push(obj);
    });
    return result;
  }
});

var ModalView = CommonPlace.View.extend({
  template: "shared/modal",
  className: "modal",

  initialize: function(options) {
    var self = this;
    this.form = this.options.form;
  },

  afterRender: function() {
    $("body").append(this.el);
    $(".modal-container").append(this.form);
    this.$("textarea").autoResize();
    this.centerEl();
  },

  centerEl: function() {
    var $el = $(".modal-container");
    var $window = $(window);
    $el.css({
      top: (($window.height() - $el.height()) /2) + $window.scrollTop(),
      left: ($window.width() - $el.width()) /2
    });

    
  },

  events: {
    "click #modal-shadow": "exit"
  },

  exit: function() {
    $(this.el).remove();
  }
});

var RepliesView = CommonPlace.View.extend({
  className: "replies",
  template: "shared/replies",
  initialize: function(options) {
    var self = this;
    this.account = options.account;
    this.collection.bind("add", function() { self.render(); });
  },
  
  afterRender: function() {
    this.$("textarea").placeholder();
    this.$("textarea").autoResize();
    this.appendReplies();
  }, 
  
  events: {
    "submit form": "sendReply"
  },

  appendReplies: function() {
    var self = this;
    var $ul = this.$("ul.reply-list");
    this.collection.each(function(reply) {
      var replyview = new ReplyItemView({ model: reply, account: self.account });
      $ul.append(replyview.render().el);
    });
  },

  sendReply: function(e) {
    e.preventDefault();
    this.collection.create({ body: this.$("[name=body]").val()});
  },
  
  accountAvatarUrl: function() { return this.account.get('avatar_url'); }
});

var ReplyItemView = WireItemView.extend({
  template: "shared/reply-item",
  initialize: function(options) {
    this.account = options.account;
    this.model = options.model;
  },

  events: {
    "click .reply-text > .author": "messageUser",
    "mouseenter": "showInfoBox"
  },

  time: function() {
    return timeAgoInWords(this.model.get("published_at"));
  },

  author: function() {
    return this.model.get("author");
  },

  authorAvatarUrl: function() {
    return this.model.get("avatar_url");
  },

  body: function() {
    return this.model.get("body");
  },

  messageUser: function(e) {
    e && e.preventDefault();

    this.model.user(function(user) {
      var formview = new MessageFormView({
        model: new Message({messagable: user})
      });
      formview.render();
    });
  },

  getInfoBox: function(callback) {
    var account = this.account
    this.model.user(function(user) {
      callback(new UserInfoBox({ model: user, account: account }));
    });
  }
});
