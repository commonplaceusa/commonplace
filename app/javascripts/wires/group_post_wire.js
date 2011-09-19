
var GroupPostWire = Wire.extend({
  modelToView: function(model) {
    return new GroupPostWireItem({model: model, account: this.options.account});
  },

  emptyMessage: "No posts here yet"
});