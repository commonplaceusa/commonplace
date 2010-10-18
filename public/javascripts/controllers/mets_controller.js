$.sammy("body")

  .post("/users/:id/met", function(c) {
    $.post(c.path, c.params, function(r) {
      merge(r, $('body'));
    }, "html");
  })