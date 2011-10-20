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
  $("#user_interest_list, #user_good_list, #user_skill_list").chosen();
});


if (!window.console || !window.console.log){
  window.console = {
    log: function(){},
    warn: function(){},
    count: function(){},
    trace: function(){},
    info: function(){}
  }
}