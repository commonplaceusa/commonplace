var UserWireItem = WireItem.extend({
  template: "wire_items/user-item",
  tagName: "li",
  className: "wire-item group-member",

  initialize: function(options) {
    this.attr_accessible(['first_name', 'last_name', 'avatar_url']);
  },

  afterRender: function() {
    this.model.bind("change", this.render, this);
  },


  events: {
    "click button": "messageUser",
    "mouseenter": "showProfile"
  },

  messageUser: function(e) {
    e && e.preventDefault();
    var formview = new MessageFormView({
      model: new Message({messagable: this.model})
    });
    formview.render();
  },

  showProfile: function(e) {
    CommonPlace.infoBox.showProfile(this.model);
  }

});
