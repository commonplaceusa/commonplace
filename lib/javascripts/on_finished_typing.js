(function($) {

  $.fn.onFinishedTyping = function(wait, callback) {

    var timeout = undefined;

    var onTimeout = function() {
      callback.apply(); 
    };  

    var onKeyUp = function() {
      clearTimeout(timeout);

      timeout = setTimeout(onTimeout, wait); 

    };

    $(this).bind("keyup", onKeyUp).bind("focusout", onTimeout);

    return this;
  };

})(jQuery);
