//= require_tree ./main_page
var CommunityPage = CommonPlace.View.extend({
  template: "main_page.main-page",
  id: "main",

  initialize: function(options) {
    this.account = CommonPlace.account;
    this.community = CommonPlace.community;
    
    this.postBox = new PostBox({ 
      account: this.account,
      community: this.community
    });

    this.lists = new CommunityResources({
      account: this.account,
      community: this.community
    });

    this.infoBox = new InfoBox({
      account: this.account,
      community: this.community
    });

    window.infoBox = this.infoBox;

    this.views = [this.postBox, this.lists, this.infoBox];
  },

  afterRender: function() {
    var self = this;
    _(this.views).each(function(view) {
      view.render();
      self.$("#" + view.id).replaceWith(view.el);
    });
  },

  bind: function() { 
    $("body").addClass("community");
    CommonPlace.layout.bind();
  },

  unbind: function() {
    $("body").removeClass("community");
    CommonPlace.layout.unbind();
  }

});


$(function() {
  
  if (Features.isActive("fixedLayout")) {
    $("body").addClass("fixedLayout");
    CommonPlace.layout = new FixedLayout();
  } else {
    CommonPlace.layout = new StaticLayout();
  }

});

//= require json2
//= require showdown
//= require jquery
//= require jquery-ui
//= require actual
//= require underscore
//= require config
//= require feature_switches
//= require placeholder
//= require time_ago_in_words
//= require scrollTo
//= require mustache
//= require backbone
//= require autoresize
//= require dropkick
//= require truncator
//= require ajaxupload
//= require views
//= require_tree ../templates/shared
//= require_tree ../templates/main_page
//= require info_boxes
//= require models
//= require en
//= require college
//= require main_page/app
//= require info_boxes
//= require wires
//= require wire_items

//= require_tree ./shared
