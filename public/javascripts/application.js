
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
  
  $('.filter').tipsy({ gravity: 's', delayOut: 0 });
 
});
