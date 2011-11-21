var PostForm = CommonPlace.View.extend({
  template: "main_page.post-form",
  tagName: "form",
  className: "create-neighborhood-post",

  events: {
    "click button": "createPost",
    "focusin input, textarea": "onFormFocus",
    "keydown textarea": "resetLayout"
  },

  afterRender: function() {
    this.$('input[placeholder], textarea[placeholder]').placeholder();
    this.$("textarea").autoResize();
    // dropkick isn't playing well with optgroups
    //this.$("select.category").dropkick();
  },
  
  createPost: function(e) {
    e.preventDefault();
    
    this.cleanUpPlaceholders();
    
    this.$(".spinner").show();
    this.$("button").hide();
    
    var data = {
      title: this.$("[name=title]").val(),
      body: this.$("[name=body]").val()
    }
    
    var isGroupPost = this.$("[name=category]").val() == "discussion";
    var groups = CommonPlace.community.groups;
    var self = this;
    
    if (isGroupPost) {
      var groupId = this.$("[name=type] option:selected").attr("data-group-id");
      groups.fetch({
        success: function() {
          var group = groups.find(function(g) {
            return g.id == groupId;
          });
          self.sendPost(group.posts, data);
        }
      });
    } else {
      data["category"] = this.$("[name=category]").val();
      this.sendPost(this.collection, data);
    }
  },
  
  sendPost: function(postCollection, data) {
    var self = this;
    postCollection.create(data, {
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

  resetLayout: function() { CommonPlace.layout.reset(); },
  
  groups: function() { return this.options.community.get('groups'); }
});
