
var PreviewWire = Wire.extend({
  template: "wires/preview-wire",
  _defaultPerPage: 5,
  showMore: function() {}, // passthrough
  areMore: function() { return false; },
  isRecent: function() { return this.options.isRecent || false; }
});
