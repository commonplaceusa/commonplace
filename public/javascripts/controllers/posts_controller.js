
$.sammy("body")

  .post("/posts")

  .post("/first_posts")

  .get("/posts/neighborhood")

  .get("/posts")

  .get("/posts/new")
  .get("/first_posts/new")

  .get("/posts/:id")
  
  .before(/\/posts\/\d+/, function() {
    accordionReplies($(this.target).siblings(".replies"));
  })
