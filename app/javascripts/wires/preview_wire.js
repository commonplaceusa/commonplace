
var PreviewWire = PaginatingWire.extend({
  template: "wires/preview-wire",
  _defaultPerPage: 3,
  fullWireLink: function() { return this.options.fullWireLink; },
  showMore: function(){alert('asd');} // override Wire to allow default button behavior.
});
