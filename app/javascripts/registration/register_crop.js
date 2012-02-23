var RegisterCropView = CommonPlace.View.extend({
  template: "registration.crop",
  
  events: {
    "click input.continue": "submit",
    "submit form": "submit"
  },
  
  afterRender: function() {
    this.options.slideIn(this.el);
    var $img = this.$("img#cropbox");
    var self = this;
    this.coords = {};
    
    $img.load(_.bind(function() {
      var scale = Math.max(
        380.0 / $img.width(),
        300.0 / $img.height()
      );
      this.$("form").css({
        width: Math.floor($img.width() * scale),
        height: Math.floor( ($img.height() * scale) + 50)
      });
      $img.css({
        width: Math.floor($img.width() * scale),
        height: Math.floor($img.height() * scale)
      });
      $img.Jcrop({
        onChange: function(coords) { self.updateCrop(coords); },
        onSelect: function(coords) { self.updateCrop(coords); },
        aspectRatio: 1.0
      });
    }, this));
  },
  
  avatar_url: function() { return CommonPlace.account.get("avatar_original"); },
  
  updateCrop: function(coords) {
    var $img = this.$("img#cropbox");
    var scale = $img[0].width / $img.width();
    if (scale) {
      this.coords = {
        crop_x: coords.x * scale,
        crop_y: coords.y * scale,
        crop_w: coords.w * scale,
        crop_h: coords.h * scale
      }
    }
  },
  
  submit: function(e) {
    if (e) { e.preventDefault(); }
    CommonPlace.account.cropAvatar(this.coords, _.bind(function() {
      this.options.nextPage("feed", this.options.data);
    }, this));
  }
});
