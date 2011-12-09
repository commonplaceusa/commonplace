$(function(){ 
  if ($("body").hasClass("faq")) {
    var setSidebarPosition = function(e) {
      var $sidebar = $('#sections_picker');
      var $main = $("#main");
      var leftOffset = $main.offset().left + $main.outerWidth() - 80;

      if ($(this).scrollTop() + 40 <= $main.offset().top) {
        $sidebar.css({position: "absolute", left: ""});
      }
      else{
        $sidebar.css({position: "fixed", left: leftOffset});
      }
    };

    $(window).scroll(setSidebarPosition).resize(setSidebarPosition);
  } 
});
