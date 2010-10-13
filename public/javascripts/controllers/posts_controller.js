
$.sammy("body")

  .post("/posts", function() {
    $.post(this.path, this.params, function(response) {
      if (response.saved) {
        $("#tooltip").html("Post Saved!").addClass("win");
        
      } else {
        
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