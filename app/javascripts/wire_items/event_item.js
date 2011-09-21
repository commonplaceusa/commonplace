var EventWireItem = WireItem.extend({
  template: "wire_items/event-item",
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
    return (this.account.get("id") == this.model.get("user_id"));
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
