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
//= require_tree ./main_page
//= require_tree ./shared

$(function() {
  
  if (Features.isActive("fixedLayout")) {
    $("body").addClass("fixedLayout");
    CommonPlace.layout = new FixedLayout();
  } else {
    CommonPlace.layout = new StaticLayout();
  }

});
