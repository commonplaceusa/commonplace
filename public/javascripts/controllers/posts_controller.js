
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


  .get("#/posts/new", function(context) {
    this.render('/posts/_form.html')
      .then(function(content) {
        context.log(content);
        $(content).modal({
          overlayClose: true,
          onClose: function() { 
            $.modal.close(); 
          }
        });
      });
  })

  .get("#/posts/:id", setInfoBox)

  .get("#/posts", setList)