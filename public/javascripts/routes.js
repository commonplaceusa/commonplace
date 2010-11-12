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

  .before(/\/announcements\/\d+/, function() {
    accordionReplies($(this.target).siblings(".replies"));
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

  .before(/\/events\/\d+/, function() {
    accordionReplies($(this.target).siblings(".replies"));
  })

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

  .post("/feeds/:feed_id/announcements")

  .get('/:messagable_type/:messagable_id/messages/new')

  .post('/users/:user_id/messages')

  .post("/users/:id/met")

  .get("/neighborhood/people")

  .get("/password_resets/new")
  .post("/password_resets")
  .get("/password_resets/:id/edit")


  .post("/posts")

  .post("/first_posts")

  .get("/posts/neighborhood")

  .get("/posts")

  .get("/posts/new")
  .get("/first_posts/new")

  .get("/posts/:id")
  
  .before(/\/posts\/\d+/, function() {
    accordionReplies($(this.target).siblings(".replies"));
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
