
$.sammy("body")

  .get("#/organizations", function(c) {
    $.get("/organizations", function(r) {
      merge(r, $("body"));
    });
  })

  .get("#/organizations/business", function(c) {
    $.get("/organizations/business", function(r) {
      merge(r, $("body"));
    });
  })

  .get("#/organizations/municipal", function(c) {
    $.get("/organizations/municipal", function(r) {
      merge(r, $("body"));
    });
  })

  .get("/management/organizations/:organization_id/profile_fields/new", function() {
      var context = this;
    $.getJSON(this.path, function(response) {
      $("#edit_profile_fields #modules").append(response.form);
    });
  })

  .get("#/organizations/:id", setInfoBox)
  .get("#/organizations/new", setModal)

  .get("#/organizations/:organization_id/announcements/new", setModal)