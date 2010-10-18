
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
    accordionReplies($(c.target).siblings(".replies"));
    $.get(c.path.slice(1), function(r) {
      merge(r, $("body"));
    }, "html");
  })
