
var PostWire = Wire.extend({
  initialize: function(options) {
    this.account = options.account;
  },

  modelToView: function(model) {
    return new PostWireItem({
      model: model,
      account: this.account
    });
  },

  emptyMessage: "No posts here yet"
});
