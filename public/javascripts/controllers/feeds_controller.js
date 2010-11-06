
$.sammy("body")

  .get("/feeds")

  .get("/feeds/business")

  .get("/feeds/municipal")

  .get("/management/feeds/:feed_id/profile_fields/new", function() {
      var context = this;
    $.getJSON(this.path, function(response) {
      $("#edit_profile_fields #modules").append(response.form);
    });
  })

  .get("/feeds/new")

  .post("/feeds")

  .put("/feeds/:id")

  .get("/feeds/:id/edit")

  .get("/feeds/:id")

  .get("/feeds/:feed_id/announcements/new")

  .post("/feeds/:feed_id/announcements", function(c) {
    $.post(c.path, c.params, function(r) {
      if (/<div id="new_post">/.test(r)) {
        merge(r,$("body"));
      } else {
        window.location = "/management/feeds/" + c.params["feed_id"] + "?welcome=1";
      }
    });
  })

  .get("/management/feeds/:id\??", function(c) {
    window.location = "/management/feeds/" + c.params["id"];
  })