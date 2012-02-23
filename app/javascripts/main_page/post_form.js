var PostForm = CommonPlace.View.extend({
  template: "main_page.forms.post-form",
  tagName: "form",
  className: "create-neighborhood-post post",

  events: {
    "click button": "createPost",
    "focusin input, textarea": "onFormFocus",
    "keydown textarea": "resetLayout",
    "focusin select": "hideLabel",
    "click select": "hideLabel",
    "focusout input, textarea": "onFormBlur",
    "mouseenter": "mouseEnter",
    "mouseleave": "mouseLeave"
  },
  
  initialize: function(options) {
    if (options) { this.template = options.template || this.template; }
  },

  afterRender: function() {
    this.$('input[placeholder], textarea[placeholder]').placeholder();
    this.$("textarea").autoResize();
  },
  
  createPost: function(e) {
    e.preventDefault();
    
    this.cleanUpPlaceholders();
    
    this.$(".spinner").show();
    this.$("button").hide();

    // Category not specified
    if (this.options.category === undefined) {
      // Show a notification
      $("#invalid_post_tooltip").show();
      this.$(".spinner").hide();
      this.$("button").show();
    }

    else {
      var data = {
        title: this.$("[name=title]").val(),
        body: this.$("[name=body]").val(),
        category: this.options.category
      };
      this.sendPost(CommonPlace.community.posts, data);
    }
  },
  
  sendPost: function(postCollection, data) {
    var self = this;
    postCollection.create(data, {
      success: function() {
        postCollection.trigger("sync");
        self.render();
        self.resetLayout();
      },
      error: function(attribs, response) {
        self.$(".spinner").hide();
        self.$("button").show();
        self.showError(response);
      }
    });
  },
  
  showError: function(response) {
    this.$(".error").text(response.responseText);
    this.$(".error").show();
  },

  onFormFocus: function() {
    $moreInputs = this.$(".on-focus");
    if (!$moreInputs.is(":visible")) {
      var naturalHeight = $moreInputs.actual('height');
      $moreInputs.css({ height: 0 });
      $moreInputs.show();
      //$moreInputs.animate(
        //{ height: naturalHeight },
        //{
        //  complete: function() { 
        //    $moreInputs.css({height: "auto"}); 
        //    CommonPlace.layout.reset();
        //  }, 
        //  step: function() {
        //    CommonPlace.layout.reset();
        //  }
        //}
      //);
      CommonPlace.layout.reset();
    }
    //CommonPlace.account.clicked_post_box(function() {
    //  $("#invalid_post_tooltip").show();
    //});
  },
  
  onFormBlur: function(e) {
    $("#invalid_post_tooltip").hide();
    if (!this.focused) {
      this.$(".on-focus").hide();
      this.resetLayout();
    }
    if (!$(e.target).val() || $(e.target).val() == $(e.target).attr("placeholder")) {
      $(e.target).removeClass("filled");
    } else {
      $(e.target).addClass("filled");
    }
  },
  
  mouseEnter: function() { this.focused = true; },
  
  mouseLeave: function() { this.focused = false; },

  resetLayout: function() { CommonPlace.layout.reset(); },
  
  hideLabel: function(e) { $("option.label", e.target).hide(); }
});

