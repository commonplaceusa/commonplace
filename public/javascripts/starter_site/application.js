function toggleEditor(id) {
  if (!tinyMCE.get(id))
    tinyMCE.execCommand('mceAddControl', false, id);
  else
    tinyMCE.execCommand('mceRemoveControl', false, id);
}

jQuery.ajaxSetup({ 
  'beforeSend': function(xhr) {
      $('form.ajax_submit').html("Please wait...");
      xhr.setRequestHeader("Accept", "text/javascript");
    }
});

jQuery.fn.submitWithAjax = function() {
  this.submit(function() {
    $.post(this.action, $(this).serialize(), null, "script");
    return false;
  });
  return this;
};



$(document).ready(function() {
  $('form.ajax_submit').submitWithAjax();
});