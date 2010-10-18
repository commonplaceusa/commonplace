
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

  .post("/events", function(c) {
    $.post(c.path, c.params, function(r) {
      merge(r, $("body"));

      $('input.date').datepicker({
        prevText: '&laquo;',
        nextText: '&raquo;',
        showOtherMonths: true,
        defaultDate: null, 
      });

    }, "html");
  })

  .get("#/events/suggested", function(c) {
    $.get("/events/suggested", function(r) {
      merge(r, $("body"));
    }, "html");
  })

  .get("#/events/new", function(c) {
    $.get("/events/new", function(r) {
      merge(r, $("body"));

      $('input.date').datepicker({
        prevText: '&laquo;',
        nextText: '&raquo;',
        showOtherMonths: true,
        defaultDate: null, 
      });

    }, "html");
  })

  .get("#/events/:id", function(c) {
    $.get(c.path.slice(1), function(r) {
      merge(r, $('body'));
    });
  })
