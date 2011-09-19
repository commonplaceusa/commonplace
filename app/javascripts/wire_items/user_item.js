var UserWireItem = WireItem.extend({
  template: "wire_items/user-item",
  tagName: "li",
  className: "wire-item",
  
  initialize: function(options) {},

  afterRender: function() {
    this.model.bind("change", this.render, this);
  },

  avatarUrl: function() {
    return this.model.get("avatar_url");
  },

  firstname: function() {
    return this.model.get("first_name");
  },

  lastname: function() {
    return this.model.get("last_name");
  },

  events: {
    "click button": "messageUser",
    "mouseenter": "showInfoBox"
  },

  messageUser: function(e) {
    e && e.preventDefault();
    var formview = new MessageFormView({
      model: new Message({messagable: this.model})
    });
    formview.render();
  },

  getInfoBox: function(callback) {
    callback(new UserInfoBox({ model: this.model, account: this.options.account }));
  }

});
