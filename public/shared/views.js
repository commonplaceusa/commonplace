
var EventItemView = CommonPlace.View.extend({
  template: "shared/event-item",
  tagName: "li",

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

});