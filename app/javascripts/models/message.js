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
    var response = [];
    if (!attribs.subject && !attribs.title) { response.push("title"); }
    if (!attribs.body) { response.push("body"); }
    if (response.length > 0) { return response; }
  }
});

var Messages = Collection.extend({ model: Message });
