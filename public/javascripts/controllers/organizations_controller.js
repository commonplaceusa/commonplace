
$.sammy("body")


  .get("/management/organizations/:organization_id/profile_fields/new", function() {
      var context = this;
    $.getJSON(this.path, function(response) {
      $("#edit_profile_fields #modules").append(response.form);
    });
  })

  .get("#/organizations/:id", setInfoBox)
  .get("#/organizations/new", setModal)
  .get("#/organizations", setList)