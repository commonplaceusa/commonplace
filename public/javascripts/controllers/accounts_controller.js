
$.sammy("body")

  .post("/account", function() {
    // Because HTML does not send empty checkboxes, Rails adds a hidden field as
    // default value. This doesn't work when we send all params with javascript,
    // so we collapse the privacy policy value here.
    this.params["user[privacy_policy]"] = 
      this.params["user[privacy_policy]"][1] || 0;
    $.post("/account", this.params, function (response) {
      if (response.success) {
        $('#registration')
          .hide('slide', {}, 500,  
                function(){ 
                  $(this).replaceWith(response.more_info)
                    .show('slide', function () {
                      renderMaps();
                    });
                });
        $('header').replaceWith(response.header);
      } else {
        $('#registration')
          .hide('slide',{}, 500,
                function(){
                  $(this).html(response.form)
                    .show('slide');
                });
      }
    }, "json");
  })
  
