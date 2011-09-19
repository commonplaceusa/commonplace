

var GroupWire = Wire.extend({
  modelToView: function(model) {
    return new GroupWireItem({model: model, account: this.options.account});
  },

  emptyMessage: "No groups here yet"
});
