
var Tour = Backbone.View.extend({
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
    "click #info-box, #community-resources, #post-box" : "end"
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

  welcome: function() {
    this.$("#tour").html(CommonPlace.render("main_page/tour/welcome", {
      community_name: this.community.get('name'),
      first_name: this.account.get('short_name')
    })).attr('class','welcome');
  },

  wire: function() {
    this.cleanUp();
    this.$("#tour").html(CommonPlace.render("main_page/tour/wire"))
      .attr('class','wire');
    this.removeShadows("#community-resources");
    this.raise("#community-resources");
    $.scrollTo(20, 700);
  },

  profile: function() {
    this.cleanUp();
    this.$("#tour").html(CommonPlace.render("main_page/tour/profile"))
      .attr('class','profile');
    this.raise("#info-box");
    $.scrollTo(250, 700);
  },

  feed: function() {
    this.cleanUp();
    this.$("#tour").html(CommonPlace.render("main_page/tour/feed"))
      .attr('class', 'feed');
    this.raise("#header");
    $.scrollTo(0, 0);
  },

  post: function() {
    this.cleanUp();
    this.$("#tour").html(CommonPlace.render("main_page/tour/post"))
      .attr('class','post');
    this.removeShadows("#post-box");
    this.raise("#post-box");
    $.scrollTo(0, 700);
  },

  end: function() {
    this.cleanUp();
    $("#tour-shadow").remove();
    $("#tour").remove();
  },

  raise: function(el) {
    $(el).css({zIndex: this.overlayLevel + 1, position: "relative"});
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
  }

});

