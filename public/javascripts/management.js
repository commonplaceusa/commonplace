
var app = $.sammy(function() { 
  this.get("#/management/organizations/:organization_id/profile_fields/new", setModal);

  this.get("#manage", function () {
    this.redirect(this.params["manage"]);
  });
  
  this.get("", function () {
    renderMaps();
  });

  this.get("#/management/invites/new", setModal);


  this.post("/management/invites", function() {
    $.post(this.path, this.params, function(response) {
      if (response.success) {
        $.modal.close();
        alert("Invitation sent");
      } else {
        $("#new_invite").replaceWith(response.form);
      }
    }, "json");
  });

  this.post("/management/email_invites", function() {
    $.post(this.path, this.params, function(response) {
      if (response.success) {
        alert("Invitation sent");
        $("#new_email_invite").replaceWith(response.form);
      } else {
        $("#new_email_invite").replaceWith(response.form);
      }
    }, "json");
  });

  this.post("/management/events/:event_id/replies", function () {
    $.post(this.path, this.params, function(response) {
      if (response.success) {
        alert("Reply added");
      } else {
        alert("Reply failed");
      }
    }, "json");
  });
});

$(function() {
  app.run();
  
  $('input.date').datepicker();
  
  $('#modules').sortable();
  $('#modules').disableSelection();

  $(".tabs").tabs();
});