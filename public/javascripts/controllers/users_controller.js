
$.sammy("body")

  .get("#/users/:user_id/messages/new", setModal)

  .get("#/users/:id", setInfoBox)

  .get("#/users", setList)