$.sammy("body")

  .get("#/avatars/:id/edit", function(c) {
    $.get(c.path.slice(1), function(r) {
      merge(r, $('body'));
      
      $("#avatar_to_crop").load(function() {
        $(window).trigger('resize.modal');
        $('#avatar_to_crop').Jcrop({
          aspectRatio: 1,
          onChange: function(args) {
            $("#avatar_x").val(args.x);
            $("#avatar_y").val(args.y);
            $("#avatar_w").val(args.w);
            $("#avatar_h").val(args.h);
          }
        });
      });
    }, "html");
  })

  .put("/avatars/:id",function(c) {
    $.put(c.path, c.params, function(r) {
      merge(r,$('body'));
    });
  })

  .any("/avatars/:id", function() {
    this.log(this.params);
    $.put(this.path, this.params, function () {
      $.modal.close();
      $("img.normal").animate({opacity: 0.0}, 500, 
                              function () { this.src = this.src + "0" })
        .animate({opacity: 1}, 500);

    });
  })
