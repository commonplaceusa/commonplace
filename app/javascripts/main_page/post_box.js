
var PostBoxOld = CommonPlace.View.extend({
  template: "main_page.post-box",
  id: "post-box",
  
  initialize: function(options) {
    this.community = options.community;
    this.account = options.account;
  },

  afterRender: function() {
    var self = this;
    _(this.forms()).each(function(view) {
      self.$(".form-container").append(view.el);
    });
    this.showTab("create-neighborhood-post");
  },

  forms: function() {
    this._forms || (this._forms = [
      (new PostForm({ collection: this.community.posts,
                      community: this.community })),

      (new EventForm({ collection: this.community.events,
                       community: this.community
                     })),
      (new GroupPostForm({ collection: this.community.groupPosts,
                           community: this.community 
                         }))
      
    ]);
    return this._forms;
  },

  switchTab: function(tab) {
    this.$(".on-focus").hide();
    this.$tabForms().removeClass("current");
    this.$tabButtons().removeClass("current");
    this.showTab(tab);
  },

  showTab: function(tab) { 
    this.$("." + tab).addClass("current"); 
    _(this.forms()).invoke("render");
    CommonPlace.layout.reset();
  },
    
  $tabForms: function() { return this.$("form"); },

  $tabButtons: function() { return this.$("a.tab-button"); },

  accountHasFeeds: function() { return this.account.get('feeds').length > 0; },

  firstFeedUrl: function() {
    if (this.account.get('feeds')[0]) {
      return "/pages/" + this.account.get('feeds')[0].id;
    } else {
      return "/feed-registrations/new";
    }
  }
});
    
var PostBox = CommonPlace.View.extend({
  template: "main_page.post-box",
  id: "post-box",
  
  afterRender: function() {
    this.temp = {}
    this.showTab("nothing");
  },
  
  switchTab: function(tab) {
    this.temp = {
      title: this.$("form input[name=title]").val(),
      body: this.$("form input[name=body]").val()
    }
    this.showTab(tab);
  },
  
  showTab: function(tab) {
    this.$("li." + tab).addClass("current");
    
    var view = this.tabs[tab]();
    view.render();
    $(view.el).addClass("current"); // to be removed b/c we don't use .current anymore
    this.$("form").replaceWith(view.el);
    
    CommonPlace.layout.reset();
  },
  
  tabs: {
    nothing: function() { return new PostForm(); },
    event: function() { return new EventForm(); },
    neighborhood: function() { return new PostForm(); },
    publicity: function() { return new PostForm(); },
    offers: function() { return new PostForm(); },
    group_post: function() { return new GroupForm(); },
    help: function() { return new PostForm(); },
    other: function() { return new PostForm(); }
  }
  
  
});

