
function initInlineForm() {
  $(".inline-form").bind("edit.inline-form", function() {
    $("[data-field]", $(this)).attr('contenteditable', true);
    $(this).addClass("editable");
  });
  $(".inline-form").bind("save.inline-form", function() {
    var data = {};
    $("[data-field]", $(this)).each(function() {
      data[$(this).attr('data-field')] = $(this).html();
    });
    $.ajax({
      type: $(this).attr('data-form-method'),
      url: $(this).attr('data-form-url'),
      data: data,
      success: function(response) {
        $("#information").replaceWith(window.innerShiv(response,false));
      }
    });
  });

  $(".inline-form").bind("revert.inline-form", function() {
    $("[data-field]", $(this)).removeAttr('contenteditable');
    $(this).removeClass("editable");
  });

  $('.inline-form').bind('image.inline-form', function() {
    var $this = $(this)
    $("#avatar-form", $this).ajaxSubmit({
      success: function(response){
        $('img.avatar', $this).attr('src',
                                    $('img.avatar', $this).attr('src') + "a");
      }
    });
  });

  $('.inline-form .inline-edit').click(function(e) {
    $(this).trigger('edit.inline-form');
  });

  $('.inline-form .inline-save').click(function(e) {
    $(this).trigger('save.inline-form');
    e.stopPropagation();
  });

  $('.inline-form .inline-cancel').click(function(e) {
    $(this).trigger('revert.inline-form');
    e.stopPropagation();
  });

}
