

var FeedWire = Wire.extend({
  modelToView: function(model) {
    return new FeedWireItem({model: model, account: this.options.account});
  },

  emptyMessage: "No feeds here yet"
});