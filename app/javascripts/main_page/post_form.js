var PostForm = CommonPlace.View.extend({
  template: "main_page.post-form",
  tagName: "form",
  className: "create-neighborhood-post",

  events: {
    "click button": "createPost",
    "click [name=commercial][value=yes]": "showPublicityWarning",
    "click [name=commercial][value=no]": "hidePublicityWarning",
    "focusin input, textarea": "onFormFocus",
    "keydown textarea": "resetLayout"
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

    var collection = this.collection;
    if ($("[name=commercial]:checked").val() == "yes") {
      collection = this.options.community.announcements;
    }

    var self = this;
    collection.create({
      title: this.$("[name=title]").val(),
      body: this.$("[name=body]").val()
    }, {
      success: function() { 
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

  showPublicityWarning: function() {
    this.$("p.warning").show();
  },

  hidePublicityWarning: function() {
    this.$("p.warning").hide();
  },

  onFormFocus: function() {
    $moreInputs = this.$(".on-focus");
    if (!$moreInputs.is(":visible")) {
      var naturalHeight = $moreInputs.actual('height');
      $moreInputs.css({ height: 0 });
      $moreInputs.show();
      $moreInputs.animate(
        // animate to it's natural height (set explicitly to
        // avoid choppiness)
        { height: naturalHeight },
        // set height back to auto so the element can
        // naturally expand/contract
        {
          complete: function() { 
            $moreInputs.css({height: "auto"}); 
            CommonPlace.layout.reset();
          }, 
          step: function() {
            CommonPlace.layout.reset();
          }
        }
      );
    }
  },

  resetLayout: function() { CommonPlace.layout.reset(); }
});
