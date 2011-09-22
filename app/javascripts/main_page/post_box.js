
var PostBox = CommonPlace.View.extend({
  template: "main_page/post-box",
  id: "post-box",
  
  initialize: function(options) {
    this.community = options.community;
    this.account = options.account;
  },

  afterRender: function() {
    var self = this;
    _(this.forms()).each(function(view) {
      view.render();
      self.$(".form-container").append(view.el);
    });
    this.showTab("create-neighborhood-post");
  },

  forms: function() {
    return [
      (new PostForm({ collection: this.community.posts,
                      community: this.community })),

      (new AnnouncementForm({ collection: this.community.announcements, 
                              account: this.account,
                              community: this.community
                            })),

      (new EventForm({ collection: this.community.events,
                       community: this.community
                     })),
      (new GroupPostForm({ collection: this.community.groupPosts,
                           community: this.community 
                         }))
      
    ];
  },

  switchTab: function(tab) {
    this.$(".on-focus").hide();
    this.$tabForms().removeClass("current");
    this.$tabButtons().removeClass("current");
    this.showTab(tab);
  },

  showTab: function(tab) { 
    this.$("." + tab).addClass("current"); 
    this.$("h1").text(this.t(tab + ".h1"));
  },
    
  $tabForms: function() { return this.$("form"); },

  $tabButtons: function() { return this.$("a.tab-button"); },

  accountHasFeeds: function() { return this.account.get('feeds').length > 0 }

});
    

      
      
  

  


