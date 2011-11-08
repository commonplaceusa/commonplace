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


function setPostBoxTop() { 
  if ($(window).scrollTop() < 60) { 
    $("#post-box").css({top: 85}); 
  } else { 
    $("#post-box").css({top: 85}); 
  } 
}

function setProfileBoxBottom() {
  if ($(document).height() - $(window).scrollTop() - $(window).height() < 65) {
    $("#info-box").css({bottom: 15});
  } else {
    $("#info-box").css({bottom: 15});
  }
}

function setProfileBoxTop() {
  var $postBox = $("#post-box");
  $("#info-box").css({
    top: $postBox.outerHeight() + parseInt($postBox.css("top"),10) + 4
  });
}

function setProfileBoxInfoUpperHeight() {
  $("#info-upper").css({
    height: $("#info-box").height() - 
      $("#info-box h2").outerHeight() - 
      $("#info-box form").outerHeight() -
      $("#info-box ul.filter").outerHeight() - 40
  });
}

$(function() {

  if (Features.isActive("fixedLayout")) {
    $('.z2, .z3, .z4').data({fixed:false});

    var adjustView = function() {
      var $navs = $('.z2, .z3, .z4');
      setPostBoxTop();
      setProfileBoxBottom();
      setProfileBoxTop();
      setProfileBoxInfoUpperHeight();

      var scrollTop = $(window).scrollTop();

      $navs.each(function() {
        var $nav = $(this),
          position = $nav.position().top,
          fixed = $nav.data('fixed');
        if ( (scrollTop > position) && !fixed) {
          $('.sub-navigation', $nav).addClass('fixed');
          $nav.data({fixed: true});
        } else if ( (scrollTop < position) && fixed) {
          $('.sub-navigation', $nav).removeClass('fixed');
          $nav.data({fixed: false});
        }
      });

    };

    $(window).scroll(adjustView).resize(adjustView);
    $("body").addClass("fixedLayout");
  }

});
