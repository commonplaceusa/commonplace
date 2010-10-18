$.sammy("body")

  .get("#/announcements", function(c) {
    $.get("/announcements", function (r) {
      merge(r, $("body"));
    }, "html");
  })

  .get("#/announcements/subscribed", function(c) {
    $.get("/announcements/subscribed", function (r) {
      merge(r, $("body"));
    }, "html");
  })


  .get("#/announcements/new", function(c) {
    $.get("/announcements/new", function(r) {
      merge(r, $("body"));
    }, "html");
  })

  .post("/announcements", function(c) {
    $.post(c.path, c.params, function(r) {
      merge(r, $("body"));
    }, "html");
  })

  .get("#/subscriptions", function(c) {
    $.get("/subscriptions", function(r) {
      merge(r, $("body"));
    }, "html");
  })

  .get("#/subscriptions/recommended", function(c) {
    $.get("/subscriptions/recommended", function(r) {
      merge(r, $("body"));
    }, "html");
  })

  .get("#/announcements/:id", function(c) {
    accordionReplies($(c.target).siblings(".replies"));
    $.get(c.path.slice(1), function(r) {
      merge(r, $('body'));
    });
  })
