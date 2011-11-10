var PostForm = CommonPlace.View.extend({
  template: "main_page/post-form",
  tagName: "form",
  className: "create-neighborhood-post",

  events: {
    "click button": "createPost",
    "click [name=commercial][value=yes]": "showPublicityWarning",
    "click [name=commercial][value=no]": "hidePublicityWarning",
    "focusin input, textarea": "onFormFocus"
  },

  afterRender: function() {
    this.$('input[placeholder], textarea[placeholder]').placeholder();
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
      success: function() { self.render(); },
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
    window.adjustView();
  },

  hidePublicityWarning: function() {
    this.$("p.warning").hide();
    window.adjustView();
  },

    onFormFocus: function() {
        $moreInputs = this.$(".on-focus");
        if (!$moreInputs.is(":visible")) {

            // animate to it's natural height (set explicitly to
            // avoid choppiness)
            var height = $moreInputs.actual('height') + 'px';
            $moreInputs.css({height:'0px'}).show().animate(
                { height: height },
                {
                    step: window.adjustView,
                    complete: function() {
                        // set height back to auto so the element can
                        // naturally expand/contract
                        $moreInputs.css({height: "auto"});
                        console.log('done');
                    }
                });
        }

    }
});
