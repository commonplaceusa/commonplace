//= require showdown
//= require jquery-1.6.1
//= require jquery-ui
//= require jquery/underscore
//= require jquery/mustache
//= require jquery/json2
//= require jquery/backbone
//= require_tree ./jquery/
//= require facebook
//= require chosen

$(function() {
  // todo: explain what this code does and put it somewhere relevent.
  $("#user_interest_list, #user_good_list, #user_skill_list").chosen();
});