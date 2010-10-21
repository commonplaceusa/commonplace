$.sammy("body")

  .get("/organizations/:organization_id/profile_fields")

  .get("/organizations/:organization_id/profile_fields/new")

  .post("/organizations/:organization_id/profile_fields", function () {
    var $target = $(this.target);
    this.params["profile_field[subject]"] = $(".subject", $target).html();
    this.params["profile_field[body]"] = $(".body", $target).html();
    $.post(this.path.slice(1), this.params, function(r) {
      merge(r, $('body'));
    }, "html");
  })
       

  .post("/organizations/:organization_id/profile_fields")

  .get("/profile_fields/:id/edit")

  .put("/profile_fields/:id", function () {
    var $target = $(this.target);
    this.params["profile_field[subject]"] = $(".subject", $target).html();
    this.params["profile_field[body]"] = $(".body", $target).html();
    $.put(this.path.slice(1), this.params, function(r) {
      merge(r, $('body'));
    }, "html");
  })

