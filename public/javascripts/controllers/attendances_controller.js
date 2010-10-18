$.sammy("body")

  .post("/events/:id/attendance", function(c) {
    $.post(c.path, c.params, function(r) {
      merge(r, $('body'));
    }, "html");
  })

  .del("#/events/:id/attendance", function(c) {
    $.del(c.path, c.params, function(r) {
      merge(r, $('body'));
    }, "html");
  })
