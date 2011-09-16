

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
