

var app = $.sammy(function() { 

  this.post("/posts", function() {
    $.post("/posts.json", this.params, function(response) {
      $("#new_post").replaceWith(response.newPost);
      if (response.success) {
        $('#wresults ul').prepend(response.createdPost);
      } else {
      
      }
    }, "json");
  });
});


$(function(){
  app.run();
});