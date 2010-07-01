

var app = $.sammy(function() { 

  this.post("/posts", function() {
    $.post(this.path, this.params, function(response) {
      $("#new_post").replaceWith(response.newPost);
      if (response.success) {
        $('#xs ul').prepend(response.createdPost);
      } else {
        alert("post validation failed");
      }
    }, "json");
  });
  
  this.post("/posts/:post_id/replies", function() {
    var $post = $("#post_" + this.params['post_id']);
    var sammy = this;
    
    $.post(this.path, this.params, function(response) {
      sammy.log(response);
      $("form.new_reply", $post).replaceWith(response.newReply);
      if (response.success) {
        $(".replies ol", $post).append(response.createdReply);
      } else {
        alert("reply validation failed");
      }
    }, "json");
  });

});


$(function(){
  app.run();
  
  $('li.post div.c').live('click', function(e) {
    $(this).siblings('.replies').slideToggle(250);
  });
    
    
  
  $("input, textarea").goodlabel();
      
 
});