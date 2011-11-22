
var PostBox = CommonPlace.View.extend({
  template: "main_page.post-box",
  id: "post-box",
  
  afterRender: function() {
    var self = this;
    _(this.forms()).each(function(view) {
      self.$(".form-container").append(view.el);
    });
    this.showTab("create-neighborhood-post");
  },

  forms: function() {
    this._forms || (this._forms = [
      (new PostForm({ collection: CommonPlace.community.posts })),
      (new EventForm({ collection: CommonPlace.community.events})),
      (new GroupPostForm({ collection: CommonPlace.community.groupPosts}))
    ]);
    return this._forms;
  },

  switchTab: function(tab) {
    this.$(".on-focus").hide();
    this.$tabForms().removeClass("current");
    this.$tabButtons().removeClass("current");
    this.showTab(tab);
    mpq.track('postbox-tab: ' + tab);
  },

  showTab: function(tab) { 
    this.$("." + tab).addClass("current"); 
    _(this.forms()).invoke("render");
    CommonPlace.layout.reset();
  },
    
  $tabForms: function() { return this.$("form"); },

  $tabButtons: function() { return this.$("a.tab-button"); },

  accountHasFeeds: function() { return CommonPlace.account.get('feeds').length > 0; },

  firstFeedUrl: function() {
    if (CommonPlace.account.get('feeds')[0]) {
      return "/pages/" + CommonPlace.account.get('feeds')[0].id;
    } else {
      return "/feed-registrations/new";
    }
  }
});
    

      
      
  

  


