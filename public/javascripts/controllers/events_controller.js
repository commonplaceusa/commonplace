
$.sammy("body")

  .get("/events")

  .get("/events/your")

  .post("/events", function(c) {
      $('input.date').datepicker({
        prevText: '&laquo;',
        nextText: '&raquo;',
        showOtherMonths: true,
        defaultDate: null, 
      });
  })

  .get("/events/suggested")

  .get("/events/new", function(c) {
      $('input.date').datepicker({
        prevText: '&laquo;',
        nextText: '&raquo;',
        showOtherMonths: true,
        defaultDate: null, 
      });
  })

  .get("/events/:id")

  .before(/\/events\/\d+/, function() {
    accordionReplies($(this.target).siblings(".replies"));
  })