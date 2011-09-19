var EventWire = Wire.extend({
  initialize: function(options) {
    this.account = options.account;
  },
  
  modelToView: function(model) {
    return new EventWireItem({
      model: model,
      account: this.account
    });
  },
  
  emptyMessage: "No events here yet"
});
