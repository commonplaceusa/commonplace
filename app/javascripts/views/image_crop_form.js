var AvatarCropFormView = FormView.extend({
  template: "shared.avatar-crop-form",
  
  afterRender: function() {
    var $img = this.$("img#cropbox");
    this.coords = {};
    var self = this;
    
    $img.load(_.bind(function() {
      this.modal.render();
      var scale = Math.max(
        380.0 / $img.width(),
        300.0 / $img.height()
      );
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
  
  save: function(callback) {
    this.model.cropAvatar(this.coords, callback);
  },
  
  showError: function(response) {
    this.$(".error").text(response.responseText);
    this.$(".error").show();
  },
  
  name: function() {
    if (this.model.get("schema") == "account") {
      return "Your";
    } else {
      return this.model.get("name");
    }
  },
  
  avatar_url: function() { return this.model.get("avatar_original"); }
  
});
