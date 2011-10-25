var Message = Repliable.extend({
  initialize: function(options) {
    this.messagable = options.messagable;
  },

  url: function() {
    return "/api" + this.messagable.get("links").messages;
  },

  name: function() {
    return this.messagable.get("name");
  },

  validate: function(attribs) {
    var missing = [];
    if (!attribs.subject && !attribs.title) { missing.push("title"); }
    if (!attribs.body) { missing.push("body"); }
    if (missing.length > 0) {
      var responseText = "Please fill in the " + missing.shift();
      _.each(missing, function(field) {
        responseText = responseText + " and " + field;
      });
      var response = {
        status: 400,
        responseText: responseText + "."
      };
      return response;
    }
  }
});

var Messages = Collection.extend({ model: Message });
