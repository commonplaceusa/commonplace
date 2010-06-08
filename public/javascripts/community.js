$(document).ready(function(){

    $("#community_name").click(function(event){
        //event.preventDefault();
        // alert( $(h1).html() );
    });

    // Ricky's stuff below:
    $("#toggles div").click(function(event){         // Click wireButton or directoryButton.      
        $("#toggles div").removeClass("mode");
        $(this).addClass("mode");
        
        var num = $(this).index();
        var other = Math.abs(num-1);
        
        $(this).parent().siblings("#stuff").children(":eq(" + other + ")").hide();
        $(this).parent().siblings("#stuff").children(":eq(" + num + ")").show();
        
        if (num == 0) {
            window.location.hash = "wire";
        } else {
            window.location.hash = "directory";
        }
        
        event.preventDefault();
        return false;   // remove this
        
    });
    
    $("ul#narrow li").click(function(){
        var choice = $(this).attr('data-choice');
        if (choice == "all"){
            $(this).parent().siblings(".alphabeta").fadeOut();
        } else {
            $(this).parent().siblings(".alphabeta").fadeIn();
        }
        
        $(this).siblings().removeClass("selected");
        $(this).addClass("selected");
    });
    
    $("label.in-field").inFieldLabels({fadeOpacity:0});
    
    // Old stuff below:
    
    $(window).bind('hashchange', function () {
        var url = window.location.hash.slice(1);

        $.ajax({
            url: url,
            dataType: 'script',
            type: "GET",
            beforeSend: function (xhr) {
        
            },
            success: function (data, status, xhr) {
        
            },
            complete: function (xhr) {
        
            },
            error: function (xhr, status, error) {
        
            }
        });
        
    });
        
    //$("label.in-field").inFieldLabels({fadeOpacity:0});
    //$(".replies").hide();
    
    $("a.show_replies").live('click', function(){
        $(this).siblings(".replies").slideToggle(300);
        return false;
    });
    
    /*
    $("#submission button").live('click',function() {
        $(this.form).append("<input type='hidden' name='commit' value='"+$(this).attr("value")+"'\>");
    });
    */
    
    if (window.location.hash == "#wire"){
        $("#wireButton").click();
    } else if (window.location.hash == "#directory"){
        $("#directoryButton").click();
    } else {
        window.location.hash = "#wire";
        $("#wireButton").click();
    }
    
    $(".intro").addClass(".right");
     
});
