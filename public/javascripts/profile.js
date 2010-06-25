$(document).ready(function() {
    
    $("#map").jellopudding("#location");
    
    $(".expand").click(function(){
        $(this).siblings(".expansion").toggle();
    });
    
    $(".rsvp").click(function(){
        $(this).children("span").toggle();
    });
    
});