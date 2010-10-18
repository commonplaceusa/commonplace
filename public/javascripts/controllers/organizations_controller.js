
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

  .get("#/organizations/new", function(c) {
    $.get(c.path.slice(1), function(r) {
      merge(r, $('body'));
    }, "html");
  })

  .post("/organizations", function(c) {
    $.post(c.path, c.params, function(r) {
      merge(r,$('body'));
    },"html");
  })

  .get("#/organizations/:id", function(c) {
    $.get(c.path.slice(1), function(r) {
      merge(r, $('body'));
    }, "text");
  })


  .get("#/organizations/:organization_id/announcements/new", setModal)