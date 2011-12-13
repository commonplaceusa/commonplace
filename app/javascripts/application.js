//= require json2
//= require showdown
//= require jquery
//= require jquery-ui
//= require actual
//= require underscore
//= require mustache
//= require backbone
//= require autoresize
//= require dropkick
//= require truncator
//= require ajaxupload
//= require placeholder
//= require time_ago_in_words
//= require scrollTo
//= require jcrop

//= require config
//= require feature_switches

//= require views
//= require models
//= require info_boxes
//= require wires
//= require wire_items

//= require_tree ./shared
//= require_tree ../templates

//= require invite_page
//= require faq_page
//= require application_initialization

var Application = Backbone.Router.extend({

  initialize: function() { 
    this.pages = {
      faq: new FaqPage({ el: $("#main") }),
      invite: new InvitePage({ el: $("#main") })
    }; 

    _.invoke(this.pages, "unbind");
  },

  routes: {
    ":community/faq": "faq",
    ":community/invite": "invite"
  },

  faq: function() { this.showPage("faq"); },

  invite: function() { this.showPage("invite"); },

  showPage: function(name) {
    var page = this.pages[name];
    if (this.currentPage != page) {
      if (this.currentPage) { this.currentPage.unbind(); }
      this.currentPage = page;
      this.currentPage.bind();
      this.currentPage.render();
      window.scrollTo(0,0);
    }
  }
  
});
