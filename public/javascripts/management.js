
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

  this.post("/management/organizations/:organization_id/profile_fields/order", function () {
    var params = 
      $.extend(this.params, 
               {
                 fields: 
                 $.map($("#modules").sortable("toArray"),
                       function(m) { return m.replace("field_", ""); })
               });

    $.post(this.path, params, function () { }, "json");
    
  });
  
  this.any("/avatars/:id", function() {
    this.log(this.params);
    $.put(this.path, this.params, function () {
      $.modal.close();
      $("img.normal").animate({opacity: 0.0}, 500, 
                              function () { this.src = this.src + "0" })
        .animate({opacity: 1}, 500);

    });
  });
  this.after(function() {

  });

  this.get("#/avatars/:id/edit", function() {
    $.getJSON(this.path.slice(1), function(response) {
      $(response.form).modal({
        overlayClose: true,
        onClose: function() { 
          $.modal.close(); 
          history.back();
        }
      });
      $('#avatar_to_crop').Jcrop({
        aspectRatio: 1,
        onChange: function (args) {
          $("#avatar_x").val(args.x)
          $("#avatar_y").val(args.y)
          $("#avatar_w").val(args.w)
          $("#avatar_h").val(args.h)
        }
      });
    });
  });
 
});



$(function() {
  app.run();
  
  $('input.date').datepicker({
    prevText: '&laquo;',
    nextText: '&raquo;',
    showOtherMonths: true,
    defaultDate: null, 
  });
  
  $('#modules').sortable();
  $('#modules').disableSelection();

  $(".tabs").tabs();
    
  $('#close_modal').click(function() {
    $.modal.close();
  });
  
  $("#edit_avatar input").change(function() {
    $(this).parent().ajaxSubmit({
      beforeSubmit: function(a,f,o) {
        o.dataType = 'json';
      },
      complete: function(xhr, textStatus) {
        $("img.normal").animate({opacity: 0.0}, 500,
                                function () { this.src = this.src + "0" })
          .animate({opacity: 1}, 500);
      }

    });
  });
  
});