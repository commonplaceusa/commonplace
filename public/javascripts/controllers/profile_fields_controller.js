$.sammy("body")

  .get("/organizations/:organization_id/profile_fields")

  .get("/organizations/:organization_id/profile_fields/new")

  .put("/organizations/:organization_id/profile_fields/order", function(c) {
    c.params["fields"] = $.map($("#modules").sortable("toArray").slice(0,-1),
                               function(m) { return m.replace("profile_field_", ""); });
    $.put(c.path, c.params, function(){},"html")
  })

  .post("/organizations/:organization_id/profile_fields", function (c) {
    var $target = $(c.target);
    c.params["profile_field[subject]"] = $(".subject", $target).html();
    c.params["profile_field[body]"] = $(".body", $target).html();
    $.post(c.path, c.params, function(r) {
      merge(r, $('body'));
    }, "html");
    $('#modules').sortable();
    $('#modules').disableSelection();
  })
       

  .post("/organizations/:organization_id/profile_fields")

  .get("/profile_fields/:id/edit")

  .put("/profile_fields/:id", function (c) {
    var $target = $(c.target);
    c.params["profile_field[subject]"] = $(".subject", $target).html();
    c.params["profile_field[body]"] = $(".body", $target).html();
    $.put(c.path, c.params, function(r) {
      merge(r, $('body'));
    }, "html");
    $('#modules').sortable();
    $('#modules').disableSelection();
  })

