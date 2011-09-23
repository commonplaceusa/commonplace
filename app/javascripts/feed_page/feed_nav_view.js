
var FeedNavView = CommonPlace.View.extend({
  template: "feed_page/feed-nav",
  id: "feed-nav",
  events: {
    "click a": "navigate"
  },

  initialize: function(options) {
    this.current = options.current || "showAnnouncements";
  },
  
  navigate: function(e) {
    e.preventDefault();
    this.current = $(e.target).attr('data-tab');
    this.trigger('switchTab', this.current);
    this.render();
  },

  classIfCurrent: function() {
    var self = this;
    return function(text) {
      return this.current == text ? "current" : "";
    };
  }
});