
function selectTab(tab) {
  $(document).ready(function(){
    $('header #' + tab).addClass('selected_nav');
  });
};

function setInfoBox() {
  $.getJSON(this.path.slice(1), function(response) {
    $("#info").html(
      response.info_box).css("top", 
        Math.max(0, $(window).scrollTop() - $("#list").offset().top));
  });
}    

var app = $.sammy(function() { 

  this.post("/posts", function() {
    $.post(this.path, this.params, function(response) {
      $("#new_post").replaceWith(response.newPost);
      $("#new_post textarea").goodlabel();
      if (response.success) {
        $('#both_columns ul').prepend(response.createdPost);
      } else {
        alert("post validation failed");
      }
    }, "json");
  });
  
  this.post("/posts/:post_id/replies", function() {
    var $post = $("#post_" + this.params['post_id']);
    var sammy = this;
    
    $.post(this.path, this.params, function(response) {
      $("form.new_reply", $post).replaceWith(response.newReply);
      $("form.new_reply textarea", $post).goodlabel();
      if (response.success) {
        $(".replies ol", $post).append(response.createdReply);
      } else {
        alert("reply validation failed");
      }
    }, "json");
  });

  this.get("#/posts/new", function() {
    $("form#new_post").show();
  });


  this.get("#/posts/:id", setInfoBox);
  this.get("#/events/:id", setInfoBox);
  this.get("#/announcements/:id", setInfoBox);

});

$(function(){
  app.run();

  $(document).bind('scrollup',function(){
    $("#info").animate({top: Math.max(0, $(window).scrollTop() - $("#list").offset().top)});
  });
  
  $('li.post div.post_clickable').live('click', function(e) {
    var $this = $(this);
    $this.siblings('.replies').slideToggle(250);
    app.location_proxy.setLocation("#" + $this.parent().attr('data-url'));
  });
    
  $('li.event').live('click', function(e) {
    var $this = $(this);
    app.location_proxy.setLocation("#" + $this.attr('data-url'));
  });
  
  $('li.announcement').live('click', function(e) {
    var $this = $(this);
    app.location_proxy.setLocation("#" + $this.attr('data-url'));
  });
  
  $("input, textarea").goodlabel();      
  $('textarea').autoResize({animateDuration: 50, extraSpace: 5});
  
  $('.filter').tipsy({ gravity: 'sw', delayOut: 0});
 
});

(function(){
  
  jQuery.event.special.scrollup = {
    setup: function() {
      var startscroll;
      jQuery(this).bind('scrollstart',function(){
        startscroll = $(window).scrollTop();
      });
      jQuery(this).bind('scrollstop',function(evt){
        var _self = this,
        _args = arguments;
        if ($(window).scrollTop() < startscroll) {
          evt.type = 'scrollup';
          jQuery.event.handle.apply(_self,_args);
        }
      });
    },
    teardown: function () {

    }
  }
 
  var special = jQuery.event.special,
  uid1 = 'D' + (+new Date()),
  uid2 = 'D' + (+new Date() + 1);
  special.scrollstart = {
    setup: function() {
      
      var timer,
      handler =  function(evt) {
        var _self = this,
        _args = arguments;
 
        if (timer) {
          clearTimeout(timer);
        } else {
          evt.type = 'scrollstart';
          jQuery.event.handle.apply(_self, _args);
        }
 
        timer = setTimeout( function(){
          timer = null;
        }, special.scrollstop.latency);
 
      };
 
      jQuery(this).bind('scroll', handler).data(uid1, handler);
 
    },
    teardown: function(){
      jQuery(this).unbind( 'scroll', jQuery(this).data(uid1) );
    }
  };
 
  special.scrollstop = {
    latency: 300,
    setup: function() {
 
      var timer,
      handler = function(evt) {
 
        var _self = this,
        _args = arguments;
        if (timer) {
          clearTimeout(timer);
        }
 
        timer = setTimeout( function(){
 
          timer = null;
          evt.type = 'scrollstop';
          jQuery.event.handle.apply(_self, _args);
 
        }, special.scrollstop.latency);
 
      };
 
      jQuery(this).bind('scroll', handler).data(uid2, handler);
 
    },
    teardown: function() {
      jQuery(this).unbind( 'scroll', jQuery(this).data(uid2) );
    }
  };
 
})();