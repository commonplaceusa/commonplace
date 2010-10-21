
$.sammy("body")

  .get("/events")

  .get("/events/your")

  .post("/events")

  .get("/events/suggested")

  .get("/events/new")

  .get("/events/:id")

  .before(/\/events\/\d+/, function() {
    accordionReplies($(this.target).siblings(".replies"));
  })