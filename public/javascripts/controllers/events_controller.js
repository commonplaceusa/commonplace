
$.sammy("body")

  .get("#/events", function(c) {
    $.get("/events", function(r) {
      merge(r, $("body"));
    }, "html");
  })

  .get("#/events/your", function(c) {
    $.get("/events/your", function(r) {
      merge(r, $("body"));
    }, "html");
  })

  .get("#/events/suggested", function(c) {
    $.get("/events/suggested", function(r) {
      merge(r, $("body"));
    }, "html");
  })

  .get("#/events/new", setModal)

  .get("#/events/:id", setInfoBox)
