
var PreviewWire = PaginatingWire.extend({
  template: "wires/preview-wire",
  _defaultPerPage: 5,
  fullWireLink: function() { return this.options.fullWireLink; },
  showMore: function() {}, // passthrough
  areMore: function() { return false; },
  isRecent: function() { return this.options.isRecent || false; }
});
