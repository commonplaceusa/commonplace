
$.sammy("body")

  .get("/organizations")

  .get("/organizations/business")

  .get("/organizations/municipal")

  .get("/management/organizations/:organization_id/profile_fields/new", function() {
      var context = this;
    $.getJSON(this.path, function(response) {
      $("#edit_profile_fields #modules").append(response.form);
    });
  })

  .get("/organizations/new")

  .post("/organizations")

  .put("/organizations/:id")

  .get("/organizations/:id/edit")

  .get("/organizations/:id")

  .get("/organizations/:organization_id/announcements/new")

  .post("/organizations/:organization_id/announcements", function(c) {
    $.post(c.path, c.params, function(r) {
      if (/<div id="new_post">/.test(r)) {
        merge(r,$("body"));
      } else {
        window.location = "/management/organizations/" + c.params["organization_id"] + "?welcome=1";
      }
    });
  })

  .get("/management/organizations/:id\??", function(c) {
    window.location = "/management/organizations/" + c.params["id"];
  })