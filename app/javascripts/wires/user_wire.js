

var UserWire = Wire.extend({
  modelToView: function(model) {
    return new UserWireItem({model: model, account: this.account});
  },

  emptyMessage: "Nobody here yet"
});