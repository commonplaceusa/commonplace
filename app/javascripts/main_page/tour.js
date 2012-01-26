
var Tour = CommonPlace.View.extend({
  id: "main",
  tagName: "div",
  
  overlayLevel: 1000,

  changedElements: [],

  events: {
    "click a.wire-tour" : "wire",
    "click a.end-tour" : "end",
    "click a.profile-tour" : "profile",
    "click a.feed-tour" : "feed",
    "click a.post-tour" : "post",
    "click #tour-shadow" : "end",
    "click #profile-box, #community-resources, #post-box" : "end"
  },

  initialize: function(options) { 
    this.account = options.account;
    this.community = options.community;
  },

  render: function() {
    $(this.el).append("<div id='tour-shadow'></div>").append("<div id='tour'></div>");
    this.welcome();
    return this;
  },

  community_name: function() { return this.community.get('name'); },

  first_name: function() { return this.account.get('short_name'); },

  welcome: function() {
    this.template = "main_page.tour.welcome";
    this.$("#tour").html(this.renderTemplate("main_page.tour.welcome", this))
      .attr('class','welcome');
    this.$("#tour").css({ 
      top: ($(window).height() - this.$("#tour").outerHeight()) /2,
      left: ($(window).width() - this.$("#tour").outerWidth()) / 2 
    });
    
  },

  wire: function() {
    this.cleanUp();
    this.template = "main_page.tour.wire";
    this.$("#tour").html(this.renderTemplate("main_page.tour.wire", this))
      .attr('class','wire');
    this.$("#tour").css({ left: $("#main").offset().left });
    this.removeShadows("#community-resources");
    this.raise("#community-resources");
  },

  profile: function() {
    this.cleanUp();
    this.template = "main_page.tour.profile";
    this.$("#tour").html(this.renderTemplate("main_page.tour.profile", this))
      .attr('class','profile');
    this.$("#tour").css({ 
      left: $("#main").offset().left + $("#profile-box").outerWidth() + 10,
      top: $("#profile-box").offset().top
    });
    this.raise("#profile-box");
  },

  feed: function() {
    this.cleanUp();
    this.template = "main_page.tour.feed";
    this.$("#tour").html(this.renderTemplate("main_page.tour.feed", this))
      .attr('class', 'feed');
    this.$("#tour").css({
      top: $("#header").outerHeight()
    });
    this.raise("#header");
  },

  post: function() {
    this.cleanUp();
    this.template = "main_page.tour.post";
    this.$("#tour").html(this.renderTemplate("main_page.tour.post", this))
      .attr('class','post');
    this.removeShadows("#post-box");
    this.raise("#post-box");
  },

  end: function() {
    this.cleanUp();
    $("#tour-shadow").remove();
    $("#tour").remove();
  },

  raise: function(el) {
    $(el).css({zIndex: this.overlayLevel + 1 });
    this.changedElements.push(el);
  },
  
  removeShadows: function(el) {
    var shadowVal = "0 0 0 transparent";
    $(el).css({"-moz-box-shadow": shadowVal, "-webkit-box-shadow": shadowVal,
               "-o-box-shadow": shadowVal, "box-shadow": shadowVal});
    this.changedElements.push(el);
  },

  cleanUp: function() {
    _(this.changedElements).each(function(e) { $(e).attr('style', ""); });
    this.changedElements = [];
    CommonPlace.layout.reset();
  }

});

