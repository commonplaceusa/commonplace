//= require jquery
//= require jquery-ui
//= require placeholder
//= require underscore
//= require mustache
//= require json2
//= require backbone
//= require autoresize
//= require dropkick
//= require chosen
//= require views
//= require models
//= require_tree ../templates/shared
//= require_tree ../templates/art_project
//= require_tree ./shared


var ArtProjectView = CommonPlace.View.extend({
  template: "art_project.main",
  id: "art_project",
  
  initialize: function(options) {
    this.communityExterior = options.communityExterior;
  },
  
  afterRender: function() {
    $("#main").append(this.el);
  },
  
  community_name: function() { return this.communityExterior.name; }
});
