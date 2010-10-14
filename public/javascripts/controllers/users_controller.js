
$.sammy("body")

  .get("#/users/:user_id/messages/new", setModal)

  .get("#/users/:id", setInfoBox)

  .get("#/users", function(c) {
    $.get("/users", function(r) {
      merge(r, $("body"));
    });
  })