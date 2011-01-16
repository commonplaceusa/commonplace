
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
        $('#information').replaceWith(response.content);
        initInlineForm();
        renderMaps();
        setInfoBoxPosition();
      },
      dataType: "json"
    });
  });

  $(".inline-form").bind("revert.inline-form", function() {
    $("[data-field]", $(this)).removeAttr('contenteditable');
    $(this).removeClass("editable");
  });

  $('.inline-form').bind('image.inline-form', function() {
    $("form", $(this)).ajaxSubmit({
      beforeSubmit: function(a,f,o) {
        o.dataType = 'json';
      },
      success: function(response){
        $("img.avatar").attr('src', response.avatar_url);
      }
    });
  });

  $('.inline-form .inline-edit').click(function(e) {
    $(this).trigger('edit.inline-form');
    e.stopPropagation();
  });

  $('.inline-form .inline-save').click(function(e) {
    $(this).trigger('save.inline-form');
    e.stopPropagation();
  });

  $('.inline-form .inline-cancel').click(function(e) {
    $(this).trigger('revert.inline-form');
    e.stopPropagation();
  });

  $('.inline-form input[type=file]').filestyle({
    image: "/images/upload.gif",
    imagewidth: 100,
    imageheight: 22
  });

}
