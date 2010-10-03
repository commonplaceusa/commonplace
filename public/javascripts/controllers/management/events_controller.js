
$.sammy("body")

  .post("/management/events/:event_id/replies", function () {
    $.post(this.path, this.params, function(response) {
      if (response.success) {
        alert("Reply added");
      } else {
        alert("Reply failed");
      }
    }, "json");
  })