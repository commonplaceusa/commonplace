
function selectTab(tab) {
  $(document).ready(function(){
    $('nav#tabs a#' + tab).addClass('selected_tab');
  });
};

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

  this.get("#/posts/:id", function() {
    $.getJSON(this.path.slice(1), function(response) {
      $("#both_columns #right_col").html(response.info_box);
    });    
  });

  this.get("#/events/:id", function() {
    $.getJSON(this.path.slice(1), function(response) {
      $("#both_columns #right_col").html(response.info_box);
    });    
  });
  
  this.get("#/announcements/:id", function() {
    $.getJSON(this.path.slice(1), function(response) {
      $("#both_columns #right_col").html(response.info_box);
    });    
  });

});


$(function(){
  app.run();
  
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
 
});