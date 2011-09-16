/****************************************************************************
// Make Styled Text Fit with .textTruncate() and .textWidth() and JQuery
//
// JQuery 1.3.x plugins to truncate the styled text inside a page element 
// until the pixel width is smaller than the goal width. Also adds a
// "title" attribute with the full text, for a tooltip on hover.
//
// Usage Example (given a div with an id of "element"):
//
//  <script type="text/javascript" src="http://ajax.googleapis.com/ajax/libs/jquery/1.3.2/jquery.min.js"></script>
//  <script type="text/javascript" src="jquery.truncate.js"></script>
//  <script type="text/javascript">
//    $(document).ready(function() {
//      var width = "250";
//      var marginText = "...";
//      $('#element').textTruncate(width,marginText);
//    });
//  </script>
//
// width = the desired pixel width
// marginText = optional text to use when truncating (default: "...")
//
// You may want to set the css to {visibility:hidden;} for the element
// by default in the CSS, so it won't initially flash at full width.
//
// Created by M. David Green (www.mdavidgreen.com) in 2009. Free to use for 
// personal or commercial purposes under MIT (X11) license with no warranty
****************************************************************************/

(function ($) {
  // A plugin to truncate the text inside an element to a given width
  // This plugin depends on the textWidth() plugin, which should be below
  $.fn.textTruncate = function(width,marginText) {
    var that = this;
    var width = width || "250"; // default width of 250 px
    var marginText = marginText || "..."; // default margin text of "..."
    that.css("visibility","hidden"); // The element should be hidden in CSS
    return this.each(function () {
      // A table as a temporary dom element for measuring the text width
      $('body').append('<table id="textWidthMeasurer" style="padding:0;margin:0;border:0;width:auto;zoom:1;position:relative;"><tr style="padding:0;margin:0;border:0;"><td style="padding:0;margin:0;border:0;white-space:nowrap;">' + marginText + '</td></tr></table>');
      var measurer = $('#textWidthMeasurer');
      var margin = measurer.textWidth(measurer); 
      if (that.textWidth(measurer) > width) {
        var contentLength = that.text().length;
        that.attr("title",that.text());
        while (that.textWidth(measurer) >= width - margin) {
          contentLength--;
          that.text(that.text().substring(0,contentLength));
        }
        that.text($.trim(that.text()) + marginText);
      }      
      // Make the element visible and remove the measuring table
      that.css("visibility","visible");
      $('#textWidthMeasurer').remove();
    });
  };
  
  // A helper plugin to get the width of the text inside an element
  $.fn.textWidth = function(context,css) {
    var that = this;
    var context = context || null;
    var css = css || null;
    // Optionally pass in an array of additional CSS properties to use for measuring
    var properties = ['font-family','font-weight','font-style','letter-spacing'];
    if ((css != null) && (css[0] != null)) {
      properties.concat(css);
    } 
    // Establish a default context if none is passed in (slow)
    if (context == null) {
      if ($('#textWidthMeasurer') == null) {
        $('body').append('<table id="textWidthMeasurer" style="padding:0;margin:0;border:0;width:auto;zoom:1;position:relative;"><tr style="padding:0;margin:0;border:0;"><td style="padding:0;margin:0;border:0;white-space:nowrap;"></td></tr></table>');
      }
      var context = $('#textWidthMeasurer');
    }
    var target = $('td',context);
    // IE uses a bizarre formula to calculate the pixel value of font sizes:
    var fontSize = ($.browser.msie) ?
      Math.sqrt(parseFloat(that.css("font-size"))/16) + "em" :
      parseFloat(that.css("font-size"))/16 + "em";
    target.text(that.text()).css('font-size',fontSize);
    properties.forEach(function(property) { 
      target.css(property,that.css(property));
    });
    var width = context.width();
    return width;
  };
})(jQuery);
