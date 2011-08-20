
var setInfoBoxPosition = (function () { // wrapped in a function to minimize globals
  var $container = $('#left-container'), // pre-select #left-container
      $win = $(window), // idk if this needs to be pre-selected but it can't hurt
      original_position, // distance from the top of the document to #left-container
      top_offset = 20, // desired offset from the top of the viewport to #left-container
      bottom_offset = 95; // desired offset from the bottom of the viewport to #left-container

  function set_original_position(jq_node) {
    // jq_node should be a jQuery object, defaults to 85
    original_position = jq_node.get(0) ? jq_node.offset().top : 85;
  }
  set_original_position($container);

  function setInfoBoxPosition() {
    var current_offset = $container.offset(),
        bottom_diff = 0;
    if ($container.get(0)) {
      if ($win.scrollTop() >= current_offset.top - top_offset && original_position <= current_offset.top) {
        bottom_diff = (current_offset.top + $container.outerHeight()) - ($(document).height() - bottom_offset);
        console.log([current_offset.top, bottom_diff, top_offset]);
        // console.log([current_offset.top, $container.height(), $(document).height(), bottom_offset]);
        $container.css({
          'position': 'fixed',
          'top': top_offset,
          'margin-top': bottom_diff > 0 ? -bottom_diff : 0,
          'padding-bottom': bottom_diff > 0 ? bottom_diff : 0
        });
        // $container.animate({
        //   'top': bottom_diff > 0 ? top_offset - bottom_diff : top_offset
        // }, 3000, 'easeOutCubic')
      } else {
        $container.css({
          'position': 'static'
        });
      }
    } else {
      // $container was not selected, try again
      $container = $('#left-container');
      set_original_position($container);
    }
  }
  return setInfoBoxPosition;
})();

CommonPlace.Info = Backbone.View.extend({
  tagName: "div",
  id: "community-profiles",
  render: function() {
    var params = this.model.toJSON();
    if (params.about) { params.about = window.linkify(params.about) ; }
    this.el.html(CommonPlace.render(this.template || this.options.template,
                                    params));
    setInfoBoxPosition();
    return this;
  }
});

CommonPlace.EventInfo = CommonPlace.Info.extend({
  template: "eventinfo",

  render: function() {
    this.el.html(CommonPlace.render(this.template,
                                    this.view()));
    setInfoBoxPosition();
    return this;
  },

  view: function() {
    var params = this.model.toJSON() || {};
    params.abbrev_month = this.model.abbrev_month_name();
    params.day_of_month = this.model.day_of_month();
    return params;
  }
});

CommonPlace.GroupInfo = CommonPlace.Info.extend({
  template: "groupinfo",

  events: {
    "click a.new_subscription": "subscribe",
    "click a.unsubscribe": "unsubscribe"
  },

  initialize: function(options) {
    var self = this ;
    CommonPlace.account.bind("change:group_subscriptions",
                             function() { self.render(); });
  },

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
      about: window.linkify(this.model.get('about')),
      isSubscribed: _.include(CommonPlace.account.get('group_subscriptions'), this.model.get('id'))
    };
  },

  subscribe: function(e) {
    e.preventDefault();
    CommonPlace.account.subscribeToGroup(this.model.id);
  },
  
  unsubscribe: function(e) {
    e.preventDefault();
    CommonPlace.account.unsubscribeFromGroup(this.model.id);
  }
});

CommonPlace.FeedInfo = CommonPlace.Info.extend({
  template: "feedinfo",

  events: {
    "click a.new_subscription": "subscribe",
    "click a.unsubscribe": "unsubscribe"
  },

  initialize: function(options) {
    var self = this;
    CommonPlace.account.bind("change:feed_subscriptions",
                             function() { self.render(); });
  },

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
      about: window.linkify(this.model.get('about')),
      tags: this.model.get('tags'),
      website: this.model.get('website'),
      phone: this.model.get('phone'),
      address: this.model.get('address'),
      isSubscribed: _.include(CommonPlace.account.get('feed_subscriptions'), this.model.get('id'))
    };
  },

  subscribe: function(e) {
    e.preventDefault();
    CommonPlace.account.subscribeToFeed(this.model.id);
  },
  
  unsubscribe: function(e) {
    e.preventDefault();
    CommonPlace.account.unsubscribeFromFeed(this.model.id);
  }
});