
$.sammy("body")

  .get("#/management/organizations/:organization_id/profile_fields/new", setModal)

  .get("#/management/organizations/:organization_id/profile_fields/:id/edit", function (context) {
    $field = $('li.profile_field#field_' +this.params.id);
    $(".subject", $field).attr('contenteditable', true);

    $(".body", $field).attr('contenteditable', true);

    $(".edit", $field).hide().after("<a href='save' class='save'>save</a>");
    $(".save", $field)
      .click(function (e) { 
        e.preventDefault();
        $.put("/management/organizations/"
              + context.params.organization_id
              + "/profile_fields/" + context.params.id,
              {"profile_field[subject]": $(".subject", $field).html(),
               "profile_field[body]": $(".body", $field).html()});
        $(".subject", $field).attr('contenteditable', false);
        $(".body", $field).attr('contenteditable', false);
        $(".save", $field).remove();
        $(".edit", $field).show();
        $.sammy("body").setLocation("#");
      });
  });
