var Message = Model.extend({
  initialize: function(options) {
    this.messagable = options.messagable;
  },

  url: function() {
    return "/api" + this.messagable.get("links").messages;
  },

  name: function() {
    return this.messagable.get("name");
  }
});