
$.sammy("body")

  .get("#/management/organizations/:organization_id/profile_fields/new", setModal)


  .post("/management/organizations/:organization_id/profile_fields/order", function () {
    var params = 
      $.extend(this.params, 
               {
                 fields: 
                 $.map($("#modules").sortable("toArray"),
                       function(m) { return m.replace("field_", ""); })
               });

    $.post(this.path, params, function () { }, "json");
    
  })