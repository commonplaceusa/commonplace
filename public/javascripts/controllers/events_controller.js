
$.sammy("body")

  .get("#/events/new", setModal)

  .get("#/events/:id", setInfoBox)

  .get("#/events", setList)