
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

  .get("/organizations/:id")
