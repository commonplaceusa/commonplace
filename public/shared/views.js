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
                 "Jul", "Aug", "Sept", "Oct", "Nov", "Dec"]

});

var AnnouncementItemView = CommonPlace.View.extend({
  template: "shared/announcement-item",
  tagName: "li",

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
  
  body: function() { return this.model.get('body'); }

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
