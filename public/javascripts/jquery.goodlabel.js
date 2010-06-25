/*
 * jQuery GoodLabel
 * Written by Richard Mondello on June 25, 2010
 */

(function($){
    $.fn.goodlabel = function() {
        $(this).each(function(){
            
            if ( $(this).attr('data-label') === undefined) {
                //alert("false false false");
                return null;
            }
            //alert("true true true");
        
            $(this).val( $(this).attr('data-label') ).addClass("label");
            $(this).data("userinput", false);

            $(this).focus(function(){
                if ($(this).val() == $(this).attr('data-label') && $(this).data("userinput") == false) {                
                    $(this).addClass("fading");
                    $(this).delay(100).queue(function(){ 
                        $(this).val("");
                        $(this).removeClass("fading").removeClass("label");
                        $(this).dequeue();
                    });
                }
            });

            $(this).blur(function() {
                if ( $(this).val() == "") {
                    $(this).addClass("fading").removeClass("label");
                    $(this).delay(100).queue(function(){
                        $(this).val( $(this).attr('data-label') );
                        $(this).removeClass("fading").addClass("label");
                        $(this).data("userinput", false);
                        $(this).dequeue();
                    });
                } else {
                    $(this).removeClass("fading, label");
                    $(this).data("userinput", true);
                }
            });

            return this;
        
        });
    }
})(jQuery);