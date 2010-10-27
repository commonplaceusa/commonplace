$.sammy("body")

  .get("/announcements")

  .get("/announcements/subscribed")

  .get("/announcements/new")

  .post("/announcements")

  .get("/subscriptions")

  .get("/subscriptions/recommended")

  .get("/announcements/:id")

  .before(/\/announcements\/\d+/, function() {
    accordionReplies($(this.target).siblings(".replies"));
  })

