
var PreviewWire = PaginatingWire.extend({
  template: "wires/preview-wire",
  _defaultPerPage: 3,
  fullWireLink: function() { return this.options.fullWireLink; },
  showMore: function() {} // passthrough
});
