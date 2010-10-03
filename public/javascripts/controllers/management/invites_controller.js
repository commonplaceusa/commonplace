
$.sammy("body")

  .get("#/management/invites/new", setModal)

  .post("/management/invites", function() {
    $.post(this.path, this.params, function(response) {
      if (response.success) {
        $.modal.close();
        alert("Invitation sent");
      } else {
        $("#new_invite").replaceWith(response.form);
      }
    }, "json");
  })

  .post("/management/email_invites", function() {
    $.post(this.path, this.params, function(response) {
      if (response.success) {
        alert("Invitation sent");
        $("#new_email_invite").replaceWith(response.form);
      } else {
        $("#new_email_invite").replaceWith(response.form);
      }
    }, "json");
  })


