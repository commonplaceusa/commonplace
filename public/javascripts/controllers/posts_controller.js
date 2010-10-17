
$.sammy("body")

  .post("/posts", function(c) {
    $.post(this.path, this.params, function(r) {
      merge(r, $("body"));
    }, "html");  
  })

  .get("#/posts/neighborhood", function(c) {
    $.get("/posts/neighborhood", function(r) {
      merge(r, $("body"));
    }, "html");
  })

  .get("#/posts", function(c) {
    $.get("/posts", function(r) {
      merge(r, $("body"));
    }, "html");
  })

  .get("#/posts/new", function(context) {
    $.get("/posts/new", function(r) {
      merge(r, $("body"));
    }, "html");
  })

  .get("#/posts/:id", function(c) {
    $.get(c.path.slice(1), function(r) {
      $(c.target).siblings(".replies").show();
      merge(r, $("body"));
    }, "html");
  })
