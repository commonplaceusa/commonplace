
CommonPlace.Tour = Backbone.View.extend({
  id: "main",
  tagName: "div",
  
  overlayLevel: 1000,

  changedElements: [],

  events: {
    "click a.wire-tour" : "wire",
    "click a.end-tour" : "end",
    "click a.profile-tour" : "profile",
    "click a.post-tour" : "post",
    "click #tour-shadow" : "end",
    "click #community-profiles, #whats-happening, #say-something" : "end"
  },

  render: function() {
    $(this.el).append("<div id='tour-shadow'></div>").append("<div id='tour'></div>");
    this.welcome();
    return this;
  },

  welcome: function() {
    this.$("#tour").html(CommonPlace.render("tour_welcome", {
      community_name: CommonPlace.community.get('name'),
      first_name: CommonPlace.account.get('short_name')
    })).attr('class','welcome');
  },

  wire: function() {
    this.cleanUp();
    this.$("#tour").html(CommonPlace.render("wire_tour")).attr('class','wire');
    this.removeShadows("#whats-happening #syndicate");
    this.removeShadows("#whats-happening #zones a:last-child");
    this.raise("#whats-happening");
    $.scrollTo(20, 700);
  },

  profile: function() {
    this.cleanUp();
    this.$("#tour").html(CommonPlace.render("profile_tour")).attr('class','profile');
    this.raise("#community-profiles");
    $.scrollTo(250, 700);
  },

  post: function() {
    this.cleanUp();
    this.$("#tour").html(CommonPlace.render("post_tour")).attr('class','post');
    this.removeShadows("#say-something");
    this.raise("#say-something");
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

//$(function() { new CommonPlace.Tour({el: $("#main")}).render() });