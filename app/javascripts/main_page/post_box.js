
var PostBox = CommonPlace.View.extend({
  template: "main_page/post-box",
  id: "post-box",
  
  initialize: function(options) {
    this.community = options.community;
    this.account = options.account;
  },

  events: {
    "click a.tab-button": "switchTabOnClick"
  },

  afterRender: function() {
  //   var self = this;
  //   _(this.forms()).each(function(form) {
  //     var view = new form({ 
  //       community: self.community,
  //       account: self.account
  //     });

  //     view.render();
      
  //     self.$(".form-container").append(view.el);
  //   });

    this.showTab("create-neighborhood-post");
  },

  forms: function() {
    return [PostForm, AnnouncementForm, EventForm, GroupPostForm];
  },

  switchTab: function(tab) {
    this.$tabForms().removeClass("current");
    this.$tabButtons().removeClass("current");
    this.showTab(tab);
  },

  showTab: function(tab) { 
    this.$("." + tab).addClass("current"); 
    this.$("h1").text(tab);
  },
    

  tabs: function() {
    return ["create-neighborhood-post",
            "create-announcement",
            "create-event",
            "create-group-post"];
  },

  $tabForms: function() { return this.$("form"); },

  $tabButtons: function() { return this.$("a.tab-button"); },

  switchTabOnClick: function(e) {
    e.preventDefault();
    var tab = $(e.target).attr('href').split("#")[1];
    this.switchTab(tab);
  }

});
    

      
      
  

  


