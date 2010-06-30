

var app = $.sammy(function() { 

  this.post("/posts", function() {
    $.post(this.path, this.params, function(response) {
      $("#new_post").replaceWith(response.newPost);
      if (response.success) {
        $('#xs ul').prepend(response.createdPost);
      } else {
        alert("reply validation failed");
      }
    }, "json");
  });
  
  this.post("/posts/:post_id/replies", function() {
    $.post(this.path, this.params, function(response) {
      $("#post_" + this.params['post_id'] + " .new_reply").replaceWith(response.newReply);
      if (response.success) {
        $("#post_" + this.params['post_id'] + " .replies").append(response.createdReply);
      } else {
        alert("reply validation failed");
      }
    }, "json");
  });

});


$(function(){
  app.run();

  $("input, textarea").goodlabel();
      
  $("#xs .left .post").click(function(e){
    var target = e.target,      // e.target grabs the node that triggered the event.
    $target = $(target);    // wraps the node in a jQuery object
    
    // stops clicking on new_reply from closing the div.
    if ( $target.closest(".new_reply").length > 0 ){ 
      return false;
    }
    
    //$(this).css("position", "relative");
    $(this).find(".replies").slideToggle();
  });

});