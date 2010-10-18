
$.sammy("body")

  .get("#/users/:user_id/messages/new", setModal)

  .get("#/users/:id", function(c) {
    $.get(c.path.slice(1), function(r) {
      merge(r, $("body"));
    }, "html");
  })

  .get("#/users", function(c) {
    $.get("/users", function(r) {
      merge(r, $("body"));
    });
  })