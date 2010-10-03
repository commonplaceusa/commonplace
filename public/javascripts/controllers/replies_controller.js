
$.sammy("body")

  .post("/replies", function() {
    var sammy = this;
    $item = $(this.target).closest('li');
    $.post(this.path, this.params, function(response) {
      $("form.new_reply", $item).replaceWith(response.newReply);
      $("form.new_reply textarea", $item).goodlabel();
      if (response.success) {
        $(".replies ul", $item).append(response.createdReply);
      } else {
        alert("reply validation failed");
      }
    }, "json");
  })