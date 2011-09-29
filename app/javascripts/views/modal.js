var ModalView = CommonPlace.View.extend({
  template: "shared/modal",
  className: "modal",

  initialize: function(options) {
    var self = this;
    this.form = this.options.form;
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
    $el.css({
      top: (($window.height() - $el.height()) /2) + $window.scrollTop(),
      left: ($window.width() - $el.width()) /2
    });

    
  },

  events: {
    "click #modal-shadow": "exit"
  },

  exit: function() {
    $(this.el).remove();
  }
});


