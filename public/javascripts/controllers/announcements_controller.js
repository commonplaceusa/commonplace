$.sammy("body")

  .get("#/announcements/new", setModal)

  .get("#/announcements/:id", setInfoBox)

  .get("#/announcements", setList)