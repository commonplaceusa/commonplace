
var GroupPostForm = CommonPlace.View.extend({
  template: "main_page.group-post-form",
  tagName: "form",
  className: "create-neighborhood-post post",
  
  initialize: function(options) {
    var self = this;
    this.group = _.find(CommonPlace.community.get("groups"), function(group) {
      return group.id == options.group_id;
    });
  },

  events: {
    "click button": "createPost",
    "focusin input, textarea": "onFormFocus",
    "keydown textarea": "resetLayout",
    "focusin select": "hideLabel",
    "click select": "hideLabel"
  },

  afterRender: function() {
    this.$('input[placeholder], textarea[placeholder]').placeholder();
    this.$("textarea").autoResize();
  },
  
  createPost: function(e) {
    e.preventDefault();
    
    var self = this;
    
    this.cleanUpPlaceholders();
    
    this.$(".spinner").show();
    this.$("button").hide();
    
    var data = {
      title: this.$("[name=title]").val(),
      body: this.$("[name=body]").val()
    }
    
    CommonPlace.community.groups.fetch(function() {
      self.collection = _.find(CommonPlace.community.groups, function(group) {
        return group.id == self.group.id;
      }).posts;
      self.sendPost(self.collection, data);
    });
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
  
  hideLabel: function(e) { $("option.label", e.target).hide(); },
  
  group_name: function() { return this.group.name; }
});
