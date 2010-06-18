/*
This Javascript file really needs an organizational cleanup. I'll do that very soon. ~ Ricky
*/

var choice;
var search;
var url = 'directory';
var lasturl = '';

function getCurrentPosition() {
    if (document.body && document.body.scrollTop)
        return document.body.scrollTop;
    if (document.documentElement && document.documentElement.scrollTop)
        return document.documentElement.scrollTop;
    if (window.pageYOffset)
        return window.pageYOffset;
    return 0;
};

$(document).ready(function(){
    
    $("#wresults li").click(function(){        
        /*
        var obj = $("#infobox").empty().clone();    // Clone an empty infobox.
        $("#infobox").remove();                     // Remove the original from the DOM.
        target = $(this).find(".info_box_content").clone().get(0);  // Get the target DOM element.
        target.style.display = "inline";            // Undo 'display: none'
        obj.append(target);                         // Put the target in our removed DOM element.
        $("#comm_right").prepend(obj);              // Put '#infobox' back.
        */
        
        /*
        $("#infobox").empty();
        target = $(this).find('.info_box_content').clone().get(0);
        target.style.display = "inline";
        $("#infobox").append( target );
        */
        
        $("#wresults ul li").removeClass('selected');
        $(this).addClass('selected');
        $("#infobox").html( $(this).attr('data-info') );    // Grab the li's data-info attribute and infobox it.
        $('#infobox textarea').autoResize({
            animateDuration : 300,
            extraSpace : 20
        });
        
        heightCheck();
        
    });
    
    // Handles the "floating" right column.
    
    var floatTarget = $("#comm_right");
    $(document).scroll(function(){
        if (getCurrentPosition() > 64){
            floatTarget.addClass('fixed');
        } else {
            floatTarget.removeClass('fixed');
        }
    });
    
    $("#wresults ul li div span").live('click', function(){
        if ( $(this).siblings(".replies").is(":visible") ){
            $(this).siblings(".replies").hide();
        } else {
            $(".replies").hide();
            $(this).siblings(".replies").show();
        }
    });
    
    $('textarea').autoResize({
        animateDuration : 300,
        extraSpace : 20
    });
    
    $("#infobox div.rsvp").live('click', function(){
        
        if ( $(this).siblings("div.message").is(":visible") ){
            $(this).siblings("form, div.message").hide();
        } else {
            $(this).siblings("form").hide();
            
            // fire off ajax...
            
            // if the response is one way, show something - if it's another way, show something else
            
            // $(this).siblings("div.message").html("derp");
            
            $(this).siblings("div.message").show();
        }
    });
    
    $("#infobox div.refer").live('click', function(){
        
        if ( $(this).siblings("form").is(":visible") ){
            $(this).siblings("form, div.message").hide();
        } else {
            $(this).siblings("div.message").hide();
            
            // we need some autocomplete going on here
            
            $(this).siblings("form").show();
        }
        
    });
    
    // Solid space for a debug function:
    $("#community_name").click(function(event){
        
    });

    // Toggling between the wire and the directory.
    $("#toggles div").click(function(event){
        $("#toggles div").removeClass("mode");  // Adjust tab styling.
        $(this).addClass("mode");
        
        var num = $(this).index();              // Switch the content over.
        var other = Math.abs(num-1);
        $(this).parent().siblings("#stuff").children(":eq(" + other + ")").hide();
        $(this).parent().siblings("#stuff").children(":eq(" + num + ")").show();
        
        $("#infobox").children().hide();        // ???
        
        if (num == 0) {
            window.location.hash = "wire";          // We're in the wire.
            
            // $(".intro").removeClass("left");
            // $(".intro").addClass("right");
            
            $("#infobox span.wire").show();
            
            // Set up the wire with default data unless there is already data there.
            
        } else {
            //alert(url);
            window.location.hash = url;             // We're in the directory.
            
            // $(".intro").removeClass("right");
            // $(".intro").addClass("left");
            
            $("#infobox span.directory").show();
            
            directoryChange();
            //alert(url);
            /*
            $.get(url, function(data) {
                $("#dresults").html(data);
            });
            */
            
            $("#left_comm").height("100%");
            
        }
        
        $("#left_comm").height("100%");
        //$("#right_comm").height("100%");
        
        event.preventDefault();     // Don't jump to anchors wire and directory on the page.
    });
    
    function keyCheck(e) {
        switch(e.keyCode) {	
    		case 13:                // return
    			directoryChange();
    			break;
    	}
    }
    
    // add style for when that form has focus...
    $("#d .intro input").keyup(keyCheck);
    
    $("footer").click(function(){
       alert("Left Height: " + $("#comm_left").height() + '\n' + "Right Height: " + $("#comm_right").height()); 
    });
    
    function heightCheck(){
        $("#comm_left").height("100%");
        if ( $("#comm_right").height() > $("#comm_left").height() ){
            $("#comm_left").height( $("#comm_right").height() );
        }
    }
    
    $("#dresults ul li").live('click', function(){
        $("#dresults ul li").removeClass('selected');
        $(this).addClass('selected');
        $("#infobox").html( $(this).attr('data-info') );    // Grab the li's data-info attribute and infobox it.
        
        $(document).ready(function(){

            $('#infobox textarea').autoResize({
                animateDuration : 300,
                extraSpace : 20
            });
        });
        
        heightCheck();
        
    });
    
    $("ul#narrow li").click(function(){
        choice = $(this).attr('data-choice');       // Grab choice.
        directoryChange();
        $("#left_comm").height("auto");
        $(this).siblings().removeClass("selected");
        $(this).addClass("selected");
    });
    
    // directoryChange can autoupdate, or be forced to update a certain way.
    function directoryChange(url) {
        if (!url){
            if (typeof choice == 'undefined') choice = 'all'    // grab valid choice
            search = $("#d .intro input").val();                // and search term,
            url = 'directory/' + choice;                        // and use them to
            if (search) url += '/' + search;                    // make a url.
        }
        
        $("#narrow li").removeClass("selected");
        $("#narrow #" + choice).addClass("selected");
        
        window.location.hash = url;
        
        if (url == lasturl){    // Prevents wasted calls. May consider putting data into a caching structure.
            return false;
        }
        
        lasturl = url;
        
        $.get(url, function(data) {
            $("#dresults").html(data);
            $("#map").jellopudding("#dresults ul");
        });
    }
    
    $("label.in-field").inFieldLabels({fadeOpacity:0});
        
    //$("label.in-field").inFieldLabels({fadeOpacity:0});
    //$(".replies").hide();
    
    $("a.show_replies").live('click', function(){
        $(this).siblings(".replies").slideToggle(300);
        return false;
    });
    
    // Initial page setup:
    if (window.location.hash == "#wire"){
        $("#wireButton").click();
    } else if (window.location.hash.indexOf("#directory") != -1){        
        url = window.location.hash.slice(1);    // Takes everything after first character. Therefore, it drops "#".
        pieces = url.split("/");        
        // alert("directory: " + pieces[0] + "\n" + "choice: " + pieces[1] + "\n" + "search: " + pieces[2]);
        if (typeof pieces[1] != "undefined") choice = pieces[1];
        if (typeof pieces[2] != "undefined") search = pieces[2];
        $("#directoryButton").click();
        //$("#map").jellopudding("#dresults");
    } else {
        window.location.hash = "#wire";
        $("#wireButton").click();
    }
    
});
