var WireView = CommonPlace.View.extend({
  className: "wire",
  template: "shared/wire",

  afterRender: function() {
    var $ul = this.$("ul.wire-list");
    _.each(this.collection, function(itemView) { 
      $ul.append(itemView.render().el);
    });
  }
});

var EventItemView = CommonPlace.View.extend({
  template: "shared/event-item",
  tagName: "li",
  className: "wire-item",

  initialize: function(options) { this.account = options.account; },

  afterRender: function() {
    var repliesView = new RepliesView({ collection: this.model.replies(),
                                        el: this.$(".replies"),
                                        account: this.account
                                      });
    repliesView.render();
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
  
  body: function() { return this.model.get('body'); },

  monthAbbrevs: ["Jan", "Feb", "Mar", "Apr", "May", "Jun",
                 "Jul", "Aug", "Sept", "Oct", "Nov", "Dec"],

  events: {
    "click a": "editEvent",
    "change": "render"
  },

  editEvent: function(e) {
    e && e.preventDefault();
    var formview = new EventFormView({
      model: this.model,
      template: "feed_page/feed-event-edit-form"
    });
    formview.render();
  }

});

var AnnouncementItemView = CommonPlace.View.extend({
  template: "shared/announcement-item",
  tagName: "li",
  className: "wire-item",

  initialize: function(options) { this.account = options.account; },

  afterRender: function() {
    var repliesView = new RepliesView({ collection: this.model.replies(),
                                        el: this.$(".replies"),
                                        account: this.account
                                      });
    repliesView.render();
  },
  
  publishedAt: function() {
    return timeAgoInWords(this.model.get('published_at'));
  },

  replyCount: function() {
    return this.model.get('replies').length;
  },

  avatarUrl: function() { return this.model.get('avatar_url'); },
  
  url: function() { return this.model.get('url'); },

  title: function() { return this.model.get('title'); },
  
  author: function() { return this.model.get('author'); },
  
  body: function() { return this.model.get('body'); },
  
  events: {
    "click a": "editAnnouncement",
    "change": "render"
  },

  editAnnouncement: function(e) {
    e && e.preventDefault();
    var formview = new AnnouncementFormView({
      model: this.model,
      template: "feed_page/feed-edit-form"
    });
    formview.render();
  }
});

var FormView = CommonPlace.View.extend({
  initialize: function(options) {
    this.template = this.options.template;
    this.modal = new ModalView({form: this.el});
    this.model.bind("create", this.modal.exit, this.modal);
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
  },

  exit: function(e) {
    e && e.preventDefault();
    this.modal.exit();
  }
});

var MessageFormView = FormView.extend({
  save: function() {
    this.model.save({
      subject: this.$("[name=subject]").val(),
      body: this.$("[name=body]").val()
    });
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
  save: function() {
    this.model.save({
      title: this.$("[name=title]").val(),
      about: this.$("[name=about]").val(),
      date: this.$("[name=date]").val(),
      start: this.$("[name=start]").val(),
      end: this.$("[name=end]").val(),
      venue: this.$("[name=venue]").val(),
      address: this.$("[name=address]").val()
    });
  },

  title: function() {
window.ev = this.model;
    return this.model.get("title");
  },

  body: function() {
    return this.model.get("body");
  },

  date: function() {
    return this.model.get("occurs_at");
  },

  venue: function() {
    console.log("hi");
    return this.model.get("venue");
  },

  address: function() {
    return this.model.get("address");
  },

  time_values: function() {
    var start_value = this.model.get("starts_at");
    var end_value = this.model.get("ends_at");
    return _.flatten(_.map(["AM", "PM"],
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
  }
});

var ModalView = CommonPlace.View.extend({
  template: "feed_page/feed-modal",
  className: "feed-modal",

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
      top: ($window.height() - $el.height()) /2,
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
    this.account = options.account;
    this.collection.bind("add", this.render, this);
  },
  
  afterRender: function() {
    this.$("textarea").placeholder();
  }, 
  
  events: { "submit form": "sendReply" },
  
  replies: function() {
    return this.collection.map(function(reply) {
      return { time: timeAgoInWords(reply.get('published_at')),
               author: reply.get('author'),
               authorAvatarUrl: reply.get('avatar_url'),
               body: reply.get('body') };
    });
  },

  sendReply: function(e) {
    e.preventDefault();
    this.collection.create({ body: this.$("[name=body]").val()});
  },
  
  accountAvatarUrl: function() { return this.account.get('avatar_url'); }
});
