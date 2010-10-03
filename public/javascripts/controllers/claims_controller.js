$.sammy("body")

  .post("/organizations/:organization_id/claim", function () {
    var context = this;
    $.post(this.path, this.params, function (response) {
      if (response.success) {
        $.modal.close();
        app.location_proxy.setLocation("#/organizations/" + context.params.organization_id + "/claim/edit");
      }
    }, "json");
  })

  .put("/organizations/:organization_id/claim", function () {
    var context = this;
    $.modal.close();
    app.location_proxy.setLocation("#/organizations/" + context.params.organization_id + "/claim/edit_fields");
  })


  .get("#/organizations/:id/claim/new", setModal)
  .get("#/organizations/:id/claim/edit", setModal)
  .get("#/organizations/:id/claim/edit_fields", setModal)


  .get("#/organizations/:id/claim/new", setModal)