

var AnnouncementWire = Wire.extend({
  initialize: function(options) {
    this.account = options.account;
  },

  modelToView: function(model) {
    return new AnnouncementWireItem({
      model: model,
      account: this.account
    });
  },

  emptyMessage: "No announcements here yet"
});