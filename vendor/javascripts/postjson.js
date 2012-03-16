
$.extend({
  postJSON: function(url, data, callback) {
    return $.ajax({
      type: "POST",
      url: url,
      contentType: "application/json",
      data: JSON.stringify(data),
      dataType: "json",
      success: callback
    });
  }
});
