var EventWireItem = WireItem.extend({
  template: "wire_items/event-item",
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
                                        account: CommonPlace.account
                                      });
    repliesView.render();
    this.model.bind("change", this.render, this);
    this.$(".event-body").truncate({max_length: 450});
    if (this.thanked())
      this.set_thanked(false, this);
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

  title: function() { return this.model.get('title'); },

  author: function() { return this.model.get('author'); },

  first_name: function() { return this.model.get('first_name'); },

  venue: function() { return this.model.get('venue'); },

  address: function() { return this.model.get('address'); },


  time: function() { return this.model.get('starts_at'); },

  body: function() {
      return this.model.get("body");
  },

  numThanks: function() {
      return this.model.get("thanks").length;
  },

  monthAbbrevs: ["Jan", "Feb", "Mar", "Apr", "May", "Jun",
                 "Jul", "Aug", "Sept", "Oct", "Nov", "Dec"],

  events: {
    "click .editlink": "editEvent",
    "mouseenter": "showProfile",
    "mouseenter .event": "showProfile",
    "click .event > .author": "messageUser",
    "click .thank-link": "thank",
    "click .share-link": "share",
    "click .reply-link": "reply",
    "blur": "removeFocus"
  },

  editEvent: function(e) {
    e && e.preventDefault();
    var formview = new EventFormView({
      model: this.model,
      template: "shared/event-edit-form"
    });
    formview.render();
  },

  canEdit: function() { return CommonPlace.account.canEditEvent(this.model); },

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
  },

  thank: function() {
    var self = this;
    $.ajax({
      url: "/api/events/" + this.model.get("id") + "/thank",
      type: "POST",
      success: function() {
        self.$(".thank_count").html(self.numThanks() + 1);
      }
    });
  },
  
  share: function(e) {
    if (e) { e.preventDefault(); }
    this.in_reply_state = false;
    this.removeFocus();
    this.$(".share-link").addClass("current");
    var shareView = new ShareView({ model: this.model,
                                    el: this.$(".replies"),
                                    account: CommonPlace.account
                                  });
     shareView.render();
   },

  reply: function(e) {
    if (e) { e.preventDefault(); }
    if (!this.in_reply_state) {
      this.removeFocus();
      this.$(".reply-link").addClass("current");
      this.render();
    }
    this.$(".reply-text-entry").focus();
    this.in_reply_state = true;
  },
  
  removeFocus: function() {
    this.$(".thank-share .current").removeClass("current");
  }

});
