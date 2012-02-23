var RegisterFeedListView = CommonPlace.View.extend({
  template: "registration.feed",
  
  events: {
    "click input.continue": "submit",
    "submit form": "submit"
  },

  afterRender: function() {
    var feeds = this.options.communityExterior.feeds;
    var $ul = this.$("ul.feeds_container");
    
    _.each(feeds, _.bind(function(feed) {
      var itemView = new this.FeedItem({ model: feed });
      itemView.render();
      $ul.append(itemView.el);
    }, this));
    
    this.options.slideIn(this.el);
    
    var height = 0;
    this.$(".feeds_container li").each(function(index) {
      if (index == 4) { return false; }
      height = height + $(this).outerHeight(true);
    });
    this.$("ul").height(height + "px");
  },
  
  community_name: function() { return this.options.communityExterior.name; },
  
  submit: function(e) {
    if (e) { e.preventDefault(); }
    
    var feeds = _.map(this.$("input[name=feeds_list]:checked"), function(feed) { return $(feed).val(); });
    if (_.isEmpty(feeds)) {
      this.finish();
    } else {
      CommonPlace.account.subscribeToFeed(feeds, _.bind(function() { this.finish(); }, this));
    }
  },
  
  finish: function() {
    this.options.nextPage("group", this.options.data);
  },
  
  FeedItem: CommonPlace.View.extend({
    template: "registration.feed-item",
    tagName: "li",
    
    events: { "click": "check" },
    
    initialize: function(options) { this.model = options.model; },
    
    avatar_url: function() { return this.model.avatar_url; },
    
    feed_id: function() { return this.model.id; },
    
    feed_name: function() { return this.model.name; },
    
    check: function(e) {
      if (e) { e.preventDefault(); }
      var $checkbox = this.$("input[type=checkbox]");
      if ($checkbox.attr("checked")) {
        $checkbox.removeAttr("checked");
        this.$(".check").removeClass("checked");
      } else {
        $checkbox.attr("checked", "checked");
        this.$(".check").addClass("checked");
      }
    }
  })
});
