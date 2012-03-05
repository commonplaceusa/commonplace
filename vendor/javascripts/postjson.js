
$.extend({
  postJSON: function(options) {
    return $.ajax({
      type: "POST",
      url: options.url,
      contentType: "application/json",
      data: JSON.stringify(options.data),
      dataType: "json",
      success: options.success,
      error: options.error
    });
  }
});
