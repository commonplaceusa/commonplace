var ModalView = CommonPlace.View.extend({
  template: "shared/modal",
  className: "modal",

  initialize: function(options) {
    var self = this;
    this.form = this.options.form;
    $("."+this.className).remove()
  },

  afterRender: function() {
    $("body").append(this.el);
    $(".modal-container").append(this.form);
    this.$("textarea").autoResize();
    this.centerEl();
  },

  centerEl: function() {
    var $el = $(".modal-container");
    var $window = $(window);
    var scrolled = $window.scrollTop();
    var top = (($window.height() - $el.height()) /2) + scrolled;
    top = top < 1 ? 10 : top;
    top = top < scrolled + 10 ? scrolled + 10 : top;
    var left = ($window.width() - $el.width()) /2;
    $el.css({ top: top, left: left });
  },

  exit: function() {
    $(this.el).remove();
  }
});


