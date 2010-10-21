$.sammy("body")

  .get("/avatars/:id/edit", function(c) {
    $.get(c.path, function(r) {
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

  .put("/avatars/:id")
