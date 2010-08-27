
var app = $.sammy(function() { 
  this.get("#/management/organizations/:organization_id/profile_fields/new", setModal);

});

$(function() {
  app.run();
  
  $('#modules').sortable();
  $('#modules').disableSelection();
  
});