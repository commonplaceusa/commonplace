CommonPlace.render = function(name, params) {
  return Mustache.to_html(
    CommonPlace.templates[name], 
    params,
    CommonPlace.templates
  );
};


var FeedPageRouter = Backbone.Controller.extend({

  routes: {
    "/feeds/:slug/profile": "show",
  },

  initialize: function(options) {
    this.account = options.account;
  },

  show: function(slug) {
    var self = this;
    $.getJSON("/api/feeds/" + slug, function(feed) {
      new FeedProfileView({ model: feed, el: $("#feed-profile")}).render();
      
      new FeedHeaderView({ feed: feed, account: self.account, el: $("#feed-header") }).render();
      $.getJSON("/api/communities/1/groups", function(groups) {
        new FeedActionsView({ el: $("#feed-actions"), feed: feed, groups: groups }).render();
      });
      var resourceView = new FeedSubResourcesView({ feed: feed, el: $("#feed-subresources") }).render();
      var resourceNav = new FeedNavView({ model: feed, el: $("#feed-nav"),  }).render();

      resourceNav.bind("switchTab", function(tab) { resourceView.switchTab(tab) });

      $.getJSON("/api/communities/1/feeds", function(feeds) {
        new FeedsListView({ model: feed, collection: feeds, el: $("#feeds-list") }).render();
      });
    });
  }
});

var FeedHeaderView = Backbone.View.extend({
  initialize: function(options) { 
    this.account = options.account; 
    this.feed = options.feed; 
  },

  events: {
    "click a.subscribe": "subscribe",
    "click a.unsubscribe": "unsubscribe"
  },

  render: function() {
    $(this.el).html(CommonPlace.render("feed-header", this));
    return this;
  },

  isSubscribed: function() {
    return _.include(this.account.feed_subscriptions, this.feed.id);
  },

  subscribe: function(e) {
    var self = this;
    e.preventDefault();
    $.ajax({
      contentType: "application/json",
      url: "/api" + this.account.links.feed_subscriptions,
      data: JSON.stringify({ id: this.feed.id }),
      type: "post",
      dataType: "json",
      success: function(account) { 
        self.account = account;
        self.render();
      }
    });
  },
  
  unsubscribe: function(e) {
    var self = this;
    e.preventDefault();
    $.ajax({
      contentType: "application/json",
      url: "/api" + this.account.links.feed_subscriptions + '/' + this.feed.id,
      type: "delete",
      dataType: "json",
      success: function(account) { 
        self.account = account;
        self.render();
      }
    });
  }
     
});

var FeedProfileView = Backbone.View.extend({
  
  events: {
    "click button.send-message": "openMessageModal"
  },
  
  render: function() {
    $(this.el).html(CommonPlace.render("feed-profile", this.model));
    return this;
  },

  openMessageModal: function() {
    var view = new FeedMessageFormView({ feed: this.model });
    view.render();
    return this;
  }
  
});

var FeedMessageFormView = Backbone.View.extend({
  className: "feed-message-modal",

  events: {
    "click form a.cancel": "exit",
    "submit form": "send"
  },
  
  initialize: function(options) { this.feed = this.options.feed },
  
  render: function() {
    var self = this;
    var $container = $("body");
    this.$shadow = $("<div/>", { 
      id: "modal-shadow",
      click: function() { self.exit() }
    });

    $(this.el).html(CommonPlace.render("feed-message-form", this));

    $container.append(this.el);
    $container.append(this.$shadow);

    this.centerEl();
  },

  centerEl: function() {
    var $el = $(this.el);
    var $window = $(window);
    
    $el.css({ top: ($window.height() - $el.height()) / 2,
              left: ($window.width() - $el.width()) / 2 
            });
  },

  send: function(e) {
    e.preventDefault();
    var self = this;
    $.ajax({
      contentType: "application/json",
      url: "/api" + this.feed.links.messages,
      type: "post",
      data: JSON.stringify({ 
        subject: this.$("[name=subject]").val(),
        body: this.$("[name=body]").val()
      }),
      dataType: "json",
      success: function(message) { 
        
        self.exit()
      }
    });
  },

  exit: function(e) {
    e && e.preventDefault();
    this.$shadow.remove();
    $(this.el).remove();
  }
});

var FeedsListView = Backbone.View.extend({
  render: function() {
    var self = this;
    $(this.el).html(CommonPlace.render("feeds-list", { 
      feeds: _(this.collection).map(function(feed) {
        return _(feed).extend({ isCurrent: feed['id'] == self.model['id'] });
      })
    }));
    return this;
  }
});

var FeedNavView = Backbone.View.extend({
  events: {
    "click a": "navigate"
  },

  initialize: function(options) {
    this.current = options.current || "announcements";
  },
  
  render: function() {
    $(this.el).html(CommonPlace.render("feed-nav", this));
    return this;
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

var FeedActionsView = Backbone.View.extend({
  events: {
    "click #feed-action-nav a": "navigate",
    "submit .post-announcement form": "postAnnouncement",
    "submit .post-event form": "postEvent",
    "submit .invite-subscribers form.invite-by-email": "inviteByEmail",
    "change .post-label-selector input": "toggleCheckboxLIClass"
  },

  initialize: function(options) {
    this.feed = options.feed;
    this.groups = options.groups;
    this.postAnnouncementClass = "current";
    _.extend(this, this.feed);
  },
  
  render: function() {
    $(this.el).html(CommonPlace.render("feed-actions", this));
    return this;
  },

  navigate: function(e) {
    var $target = $(e.target);
    $target.addClass("current")
      .siblings().removeClass("current");
    $(this.el).children(".tab")
      .removeClass("current")
      .filter("." + $target.attr('href').slice(2))
      .addClass("current");
    e.preventDefault();
  },

  toggleCheckboxLIClass: function(e) {
    $(e.target).closest("li").toggleClass("checked");
  },

  postAnnouncement: function(e) {
    var $form = $(e.target);
    e.preventDefault();
    $.ajax({
      contentType: "application/json",
      url: "/api" + this.feed.links.announcements,
      data: JSON.stringify({ title:  $("[name=title]", $form).val(),
                             body:   $("[name=body]", $form).val(),
                             groups: $("[name=groups]:checked", $form).map(function() { return $(this).val(); })
                           }),
      type: "post",
      dataType: "json",
      success: function() { alert("announcement sent")}});
  },

  postEvent: function(e) {
    var $form = $(e.target);
    e.preventDefault();
    $.ajax({
      contentType: "application/json",
      url: "/api" + this.feed.links.events,
      data: JSON.stringify({ title:   $("[name=title]", $form).val(),
                             about:   $("[name=about]", $form).val(),
                             date:    $("[name=date]", $form).val(),
                             start:   $("[name=start]", $form).val(),
                             end:     $("[name=end]", $form).val(),
                             venue:   $("[name=venue]", $form).val(),
                             address: $("[name=address]", $form).val(),
                             tags:    $("[name=tags]", $form).val(),
                             groups:  $("[name=groups]:checked", $form).map(function() { return $(this).val(); })
                           }),
      type: "post",
      dataType: "json",
      success: function() { alert("event sent")}});
  },


  time_values: _.flatten(_.map(["AM", "PM"],
                               function(half) {
                                 return  _.map(_.range(1,13),
                                               function(hour) {
                                                 return _.map(["00", "30"],
                                                              function(minute) {
                                                                return String(hour) + ":" + minute + " " + half;
                                                              });
                                               });
                               })),

  inviteByEmail: function(e) {
    var $form = $(e.target);
    e.preventDefault();
        $.ajax({
          contentType: "application/json",
          url: "/api" + this.feed.links.invites,
          data: JSON.stringify({ emails: _.map($("[name=emails]", $form).val().split(/,|;/), 
                                               function(s) { return s.replace(/\s*/,""); }),
                                 message: $("[name=message]", $form).val()
                               }),
          type: "post",
          dataType: "json",
          success: function() { alert("invites sent")}});
  }
});

var FeedSubResourcesView = Backbone.View.extend({
  initialize: function(options) {
    this.feed = options.feed;
    this.currentTab = options.current || "announcements";
    window.rview = this;
  },

  render: function() {
    this.el.html(CommonPlace.render("feed-subresources", this));
    this[this.currentTab]();
    return this;
  },

  announcements: function() {
    var self = this;
    $.getJSON("/api" + this.feed.links.announcements, function(announcements) {
      _.each(announcements, function(announcement) {
        var view = new AnnouncementItemView({model: announcement});
        view.render();
        self.$(".feed-announcements ul").append(view.el);
      });
    });
  },

  events: function() {
    var self = this;
    $.getJSON("/api" + this.feed.links.events, function(events) {
      _.each(events, function(event) {
        var view = new EventItemView({model: event});
        view.render();
        self.$(".feed-events ul").append(view.el);
      });
    });
  },

  tabs: function() {
    return { announcements: this.$(".feed-announcements"),
             events: this.$(".feed-events") };
  },

  classIfCurrent: function() {
    var self = this;
    return function(text) {
      return text == self.currentTab ? "current" : "";
    };
  },

  switchTab: function(newTab) {
    console.log(this);
    this.tabs()[this.currentTab].hide();
    this.currentTab = newTab;
    this.tabs()[this.currentTab].show();
    this.render();
  }
});

var AnnouncementItemView = Backbone.View.extend({
  render: function() {
    $(this.el).html(this.model.title);
  }
});

var EventItemView = Backbone.View.extend({
  render: function() {
    $(this.el).html(this.model.title);
  }
});



$(function() {
  $.getJSON("/api/account", function(account) {

    new FeedPageRouter({ account: account });
    window.location.hash = window.location.pathname;
    Backbone.history.start();

  });
});
