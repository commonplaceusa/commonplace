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


  .get("#/announcements/new", setModal)

  .get("#/announcements/:id", setInfoBox)


