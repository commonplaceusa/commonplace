$.sammy("body")

  .post("/account")
  .put("/account")
  .get("/account/edit")
  .get("/account/edit_new")
//  .put("/account/update_new")
  .get("/account/edit_avatar")
  .put("/account/update_avatar")
  .get("/announcements")
  .get("/announcements/subscribed")
  .get("/announcements/new")
  .post("/announcements")
  .get("/announcements/:id")
  .get("/subscriptions")
  .get("/subscriptions/recommended")

  .before(/\/announcements\/(\d+)/, function(c) {
    accordionItem($(".item" + ".announcement_" + c.params.id));
  })

  .post("/events/:id/attendance")
  .del("/events/:id/attendance")

  .get("/avatars/:id/edit")
 //.put("/avatars/:id")

  .get("/organizations/:organization_id/claim/new")
  .post("/organizations/:organization_id/claim")


  .get("/events")
  .get("/events/your")
  .post("/events")
  .get("/events/suggested")
  .get("/events/new")
  .get("/events/:id")

  .before(/\/events\/(\d+)/, function(c) {
    accordionItem($(".item" + ".event_" + c.params.id));
  })

  .get("/feeds/business")
  .get("/feeds/municipal")
  .get("/management/feeds/:feed_id/profile_fields/new", function() {
      var context = this;
    $.getJSON(this.path, function(response) {
      $("#edit_profile_fields #modules").append(response.form);
    });
  })


  .get("/feeds/:feed_id/announcements/new")

  .post("/feeds/:feed_id/announcements")

  .get('/:messagable_type/:messagable_id/messages/new')

  .post('/users/:user_id/messages')

  .post("/users/:id/met")

  .get("/neighborhood/people")

  .post("/posts")

  .post("/first_posts")

  .get("/posts/neighborhood")

  .get("/posts")

  .get("/posts/new")
  .get("/first_posts/new")

  .get("/posts/:id")
  
  .before(/\/posts\/(\d+)/, function(c) {
    accordionItem($(".item" + ".post_" + c.params.id));
  })


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

  .post("/replies")

  .get('/dmca')
  .get('/privacy')
  .get('/terms')

  .post("/feeds/:id/subscription")
  .del("/feeds/:id/subscription")


  .get("/users/:id")
  
  .get("/users")
