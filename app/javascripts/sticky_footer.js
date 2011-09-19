$(function () {
  // position the footer when window resizes
  if ($('#sticky-wrapper').get(0)) {
    function positionFooter() {
      if ($(window).height() >= $(document).height()) {
        $('html, body').css('height', '100%');
      } else {
        $('html, body').css('height', '');
      }
    }

    positionFooter();
    $(window).resize(positionFooter);
  }
});