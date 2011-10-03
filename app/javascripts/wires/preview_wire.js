
var PreviewWire = PaginatingWire.extend({
  template: "wires/preview-wire", 
  events: {},
  fullWireLink: function() { return this.options.fullLink; }
});
