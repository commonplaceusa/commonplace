
$.sammy("body")

  .post("/posts", function() {
    $.post(this.path, this.params, function(response) {
      $("#new_post").replaceWith(response.newPost);
      $("#new_post textarea").goodlabel();
      if (response.success) {
        $('ul#wire').prepend(response.createdPost);
      } else {
        alert("post validation failed");
      }
      $.modal.close();
    }, "json");  
  })


  .get("#/posts/new", setModal)

  .get("#/posts/:id", setInfoBox)

  .get("#/posts", setList)