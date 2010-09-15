
var app = $.sammy(function() { 
  this.get("#/management/organizations/:organization_id/profile_fields/new", setModal);

  this.get("#manage", function () {
    this.redirect(this.params["manage"]);
  });
  
  this.get("", function () {
    renderMaps();
  });
  
});

$(function() {
  app.run();
  
  $('#modules').sortable();
  $('#modules').disableSelection();

  $(".tabs").tabs();
});