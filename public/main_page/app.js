var CommonPlace = CommonPlace || {};
CommonPlace.MainPageController = Backbone.Controller.extend({
  
  initialize: function(options) {
    this.view = new CommonPlace.SaySomething({el: $("#say-something")});
    this.community = options.community;
    this.profile = new CommonPlace.Info({el: $("#community-profiles")});
    new CommonPlace.Index({el: $("#whats-happening")});
    this.newPost();
    this.notifications = [];

    var didscroll = false;  
    $(window).scroll(function() { didscroll = true; });
    
    setInterval(function() {
      if (didscroll) {
        didscroll = false;
        setInfoBoxPosition();
      }
    }, 100); 
    
    setInfoBoxPosition();        
    
    $("body").trigger("#modal");

  },

  text: function(template,key) {
    return CommonPlace.text[this.community.get('locale')][template][key];
  },

  routes: {
    "/tour": "tour",
    
    "/posts/new" : "newPost",
    "/events/new" : "newEvent",
    "/announcements/new" : "newAnnouncement",
    "/group_posts/new" : "newGroupPost",

    "/posts/:id/edit" : "editPost",
    "/events/:id/edit" : "editEvent",
    "/announcements/:id/edit" : "editAnnouncement",
    "/group_posts/:id/edit" : "editGroupPost",

    "/posts/:id/delete" : "deletePost",
    "/events/:id/delete" : "deleteEvent",
    "/announcements/:id/delete" : "deleteAnnouncement",
    "/group_posts/:id/delete" : "deleteGroupPost", 

    "/users/:id/messages/new" : "newMessage",

    "/events/:id/info": "event",
    "/users/:id/info": "user",
    "/groups/:id/info": "group",
    "/feeds/:id/info": "feed",

    "/events": "events",
    "/announcements": "announcements",
    "/posts": "posts",
    "/group_posts" : "group_posts",

    "/users": "users",
    "/feeds": "feeds",
    "/groups": "groups",

    "/": "wire",

    "/posts/:id": "showPost",
    "/announcements/:id": "showAnnouncement",
    "/group_posts/:id": "showGroupPost",
    "/events/:id": "showEvent",
    "/users/:id": "showUser",
    "/feeds/:id": "showFeed",
    "/groups/:id": "showGroup"

  },

  newPost : function() { 
    this.view.template = "post_form";
    this.view.model = new CommonPlace.Post({},{collection: CommonPlace.community.posts });
    this.view.render();
  },
  
  newEvent : function() {
    this.view.template = "event_form";
    this.view.model = new CommonPlace.Event({},{collection: CommonPlace.community.events });
    this.view.render();
  },
  
  newAnnouncement : function() { 
    this.view.template = "announcement_form";
    this.view.model = new CommonPlace.Announcement({}, {collection: CommonPlace.community.announcements });
    this.view.render();
  },

  newGroupPost : function() { 
    this.view.template = "group_post_form";
    this.view.model = new CommonPlace.GroupPost({}, {collection: CommonPlace.community.group_posts});
    this.view.render();
  },

  newMessage: function(person_id) {
    new CommonPlace.NewMessage({person_id: person_id}).render();
    $(window).trigger('resize.modal');
  },

  editPost : function(id) {
    var post = this.community.posts.get(id);
    if (post) {
        var view = new CommonPlace.EditView({
            model: post,
            model_type: "post"
        });
        view.render();
    }
  },

  editEvent : function(id) {
    var item = this.community.events.get(id);
    if (item) {
        new CommonPlace.EditView({
            model: item,
            model_type: "event"
        }).render();
    }
  },

  editGroupPost : function(id) {
    var item = this.community.group_posts.get(id);
    if (item) {
        new CommonPlace.EditView({
            model: item,
            model_type: "group_post"
        }).render();
    }
  },

  editAnnouncement : function(id) {
    var item = this.community.announcements.get(id);
    if (item) {
        new CommonPlace.EditView({
            model: item,
            model_type: "announcement"
        }).render();
    }
  },

  deletePost : function(id) {
    var post = this.community.posts.get(id);
    if (post) {
        var view = new CommonPlace.DeleteView({
            model: post,
            model_type: "post"
        });
        view.render();
    }
  },

  deleteEvent : function(id) {
    var item = this.community.events.get(id);
    if (item) {
        new CommonPlace.DeleteView({
            model: item,
            model_type: "event"
        }).render();
    }
  },

  deleteGroupPost : function(id) {
    var item = this.community.group_posts.get(id);
    if (item) {
        new CommonPlace.DeleteView({
            model: item,
            model_type: "group_post"
        }).render();
    }
  },

  deleteAnnouncement : function(id) {
    var item = this.community.announcements.get(id);
    if (item) {
        new CommonPlace.DeleteView({
            model: item,
            model_type: "announcement"
        }).render();
    }
  },


  event: function(id) {
    var event = this.community.events.get(id);
    if (event) {
      var view = new CommonPlace.EventInfo({el: $("#community-profiles"),
                                            model: event});
    view.render();
    }
  },

  user: function(id) {
    var user = this.community.users.get(id);
    if (user) {
      this.renderProfile(user, "userinfo");
    }
  },

  feed: function(id) {
    var feed = this.community.feeds.get(id);
    if (feed) {
      var view = new CommonPlace.FeedInfo({el: $("#community-profiles"),
                                           model: feed});
      view.render();
    }
  },

  group: function(id) {
    var view = new CommonPlace.GroupInfo({el: $("#community-profiles"),
                                          model: this.community.groups.get(id)});
    view.render();      
  },

  renderProfile: function(model, template) {
    this.profile.model = model;
    this.profile.template = template;
    this.profile.render();
  },
  
  wire: function() {
    (new CommonPlace.Wire({model: this.community,
                           el: $("#whats-happening")})).render();
    
  },

  posts: function() {
    var self = this;
    this.community.posts.fetch({success: function(r) {
      self.postIndex = self.postIndex ||
        new CommonPlace.Index({
          collection: self.community.posts,
          el: $("#whats-happening"),
          itemView: CommonPlace.PostItem,
          subnav: [{url: "#/posts", current: true, last: true, name: self.text('index',"posts-title")}],
          zone: "posts"
        });
      self.postIndex.render();
    }});
  },
  
  showPost: function(id) { 
    var self = this;
    var post = this.community.posts.get(id)
    var view = new CommonPlace.Index({
      collection: _([post]),
      el: $("#whats-happening"),
      itemView: CommonPlace.PostItem,
      subnav: [{url: "#/posts", current: true, last: true, name: self.text('index',"posts-title")}],
      zone: "posts"
    });
    view.render();
    $("#post-" + id + "-item" + " a.show-reply-form").click();
  },

  showAnnouncement: function(id) { 
    var self = this;
    var announcement = this.community.announcements.get(id)
    var view = new CommonPlace.Index({
      collection: _([announcement]),
      el: $("#whats-happening"),
      itemView: CommonPlace.AnnouncementItem,
      subnav: [{url: "#/announcements", current: true, last: true, name: self.text('index',"announcements-tab")}],
      zone: "announcements"
    });
    view.render();
    $("#announcement-" + id + "-item" + " a.show-reply-form").click(); 
  },

  showGroupPost: function(id) { 
    var self = this;
    var post = this.community.group_posts.get(id)
    var view = new CommonPlace.Index({
      collection: _([post]),
      el: $("#whats-happening"),
      itemView: CommonPlace.GroupPostItem,
      subnav: [{url: "#/group_posts", current: true, last: true, name: self.text('index',"group-posts-tab")}],
      zone: "posts"
    });
    view.render();
    $("#group_post-" + id + "-item" + " a.show-reply-form").click(); 
  },
  showEvent: function(id) { 
    var self = this;
    var event = this.community.events.get(id)
    var view = new CommonPlace.Index({
      collection: _([event]),
      el: $("#whats-happening"),
      itemView: CommonPlace.EventItem,
      subnav: [{url: "#/events", current: true, last: true, name: self.text('index',"events-tab")}],
      zone: "events"
    });
    view.render();
    $("#event-" + id + "-item" + " a.show-reply-form").click(); 
    
  },
  showUser: function(id) { this.users();
                           $.scrollTo($("#user-" + id + "-item"));
                         },
  showFeed: function(id) { this.feeds();
                           $.scrollTo($("#feed_" + id + "_item"));
                         },
  showGroup: function(id) { this.groups();
                            $.scrollTo($("#group_" + id + "_item"));
                          },

  announcements: function(){
    var self = this;
    this.community.announcements.fetch({success: function() {
      self.announcementIndex = self.announcementIndex ||
        new CommonPlace.Index({
          collection: self.community.announcements,
          el: $("#whats-happening"),
          itemView: CommonPlace.AnnouncementItem,
          subnav: [{url:"#/announcements", name: self.text('index',"announcements-tab"), current: true},
                   {url:"#/feeds", name: self.text('index',"feeds-tab"), last:true}],
          zone: "announcements"
        });
      self.announcementIndex.render();
    }});
  },

  events: function(){
    var self = this;
    this.community.events.fetch({success: function() {
      self.eventIndex = self.eventIndex ||
        new CommonPlace.Index({
          collection: self.community.events,
          el:$("#whats-happening"),
        itemView: CommonPlace.EventItem,
          subnav: [{url: "#/events", name: self.text('index',"events-tab"), current: true, last: true}],
          zone: "events"
        });
      self.eventIndex.render();
    }});
  },

  group_posts: function(){
    var self = this;
    this.community.group_posts.fetch({success: function() {
      self.group_postIndex = self.group_postIndex ||
        new CommonPlace.Index({
          collection: self.community.group_posts,
          el: $("#whats-happening"),
          itemView: CommonPlace.GroupPostItem,
          subnav: [{url: "#/group_posts", name: self.text('index',"group-posts-tab"), current: true},
                   {url: "#/groups", name: self.text('index',"groups-tab"), last: true}],
          zone: "group_posts"
        });
      self.group_postIndex.render();
    }});
  },
  
  directorySubnav: function(current_url) {
    var self = this;
    return _([{url: "#/users", name: self.text('index',"users-tab")},
              {url: "#/feeds", name: self.text('index',"feeds-tab")},
              {url: "#/groups", name: self.text('index',"groups-tab"), last: true}]).map(
                function(nav) {
                  return _.extend(nav, {current: current_url == nav.url});
                });
  },

  groups: function(){
    var self = this;
    this.community.groups.fetch({success: function() {
      self.groupIndex = self.groupIndex ||
        new CommonPlace.Index({
          collection: self.community.groups,
          el: $("#whats-happening"),
          itemView: CommonPlace.GroupItem,
          subnav: self.directorySubnav("#/groups"),
          zone: "users"
        });
      self.groupIndex.render();
    }});
  },

  feeds: function(){
    var self = this;
    this.community.feeds.fetch({success: function() {
      self.feedIndex = self.feedIndex ||
        new CommonPlace.Index({collection: self.community.feeds,
                               el: $("#whats-happening"),
                               itemView: CommonPlace.FeedItem,
                               subnav: self.directorySubnav("#/feeds"),
                               zone: "users"
                              });
      self.feedIndex.render();
    }});
  },
  users: function(){
    var self = this;
    this.community.users.fetch({success: function() {
      self.userIndex = self.userIndex ||
        new CommonPlace.Index({collection: self.community.users,
                               el: $("#whats-happening"),
                               itemView: CommonPlace.UserItem,
                               subnav: self.directorySubnav("#/users"),
                               zone: "users"
                              });
      self.userIndex.render();
    }});
  },

  runNotifier: function() {
    if (CommonPlace.app.notifications && CommonPlace.app.notifications.length > 0 && !CommonPlace.app.notificationInProgress) {
      CommonPlace.app.notificationInProgress = true;
      
      var notification = CommonPlace.app.notifications.shift();
      $notification = $('<div style="display:none;" class="notification ' + notification.classes + '">' + notification.message + '</div>');
      $notification.appendTo($("#main")).show('slide', {}, 500, function() { 
        _.delay(function() {
          $(".notification").hide('slide', {}, 800, 
                                  function() { 
                                    $(".notification").remove() ;
                                    CommonPlace.app.notificationInProgress = false ;
                                  });
        }, 1000);
      });
    }
    _.defer(CommonPlace.app.runNotifier);
  },

  notify: function(message, classes) {
    CommonPlace.app.notifications || (CommonPlace.app.notifications = []);
    CommonPlace.app.notifications.push({message: message, classes: classes});
  },

  tour: function() { (new CommonPlace.Tour({el: $("#main")})).render(); }
  
});

