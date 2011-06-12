
function setInfoBoxPosition() {
  if ($('#information').get(0) && $('#syndicate').get(0)) {
    if ($(window).scrollTop() - 10 > $('#information').parent().offset().top){
      var left;
      if ($(window).scrollLeft() != 0) { left = - $(window).scrollLeft(); } else { left = null ;}
      $('#information').css({'position':'fixed','top': 10, 'width':485, left: left });
    } else {
      $('#information').css({'position': 'static'});
    }
  }
}

CommonPlace.Info = Backbone.View.extend({
  tagName: "div",
  id: "community-profiles",
  render: function() {
    this.el.html(CommonPlace.render(this.template || this.options.template,
                                    this.model.toJSON()));
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
      about: this.model.get('about'),
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
      about: this.model.get('about'),
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