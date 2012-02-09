var RegisterCropView = CommonPlace.View.extend({
  template: "registration.crop",
  
  events: {
    "click input.continue": "submit"
  },
  
  afterRender: function() {
    this.options.slideIn(this.el);
    var $img = this.$("img#cropbox");
    var self = this;
    this.coords = {};
    
    $img.load(_.bind(function() {
      this.scale = Math.max(
        380.0 / $img.width(),
        300.0 / $img.height()
      );
      this.$("form").css({
        width: Math.floor($img.width() * this.scale),
        height: Math.floor( ($img.height() * this.scale) + 50)
      });
      $img.css({
        width: Math.floor($img.width() * this.scale),
        height: Math.floor($img.height() * this.scale)
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
    this.coords = {
      crop_x: coords.x * this.scale,
      crop_y: coords.y * this.scale,
      crop_w: coords.w * this.scale,
      crop_h: coords.h * this.scale
    }
  },
  
  submit: function(e) {
    if (e) { e.preventDefault(); }
    CommonPlace.account.cropAvatar(this.coords, _.bind(function() {
      this.options.nextPage("feed");
    }, this));
  }
});
