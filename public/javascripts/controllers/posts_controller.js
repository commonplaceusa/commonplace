
$.sammy("body")

  .post("/posts")

  .get("/posts/neighborhood")

  .get("/posts")

  .get("/posts/new")

  .get("/posts/:id")
  
  .before(/\/posts\/\d+/, function() {
    accordionReplies($(this.target).siblings(".replies"));
  })
