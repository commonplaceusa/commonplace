/*
This Javascript file really needs an organizational cleanup. I'll do that very soon. ~ Ricky

TODO:
* Loading image when an ajax call is firing.
* Caching system so that calls don't refire.

*/

var debug = false;       // Used for short-circut evaluation of alert debug statements.
var choice;
var search;
var url = 'directory';
var lasturl = '';
var action;

// Handles different browser implementations of checking height.
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
    
    $("#i .newthread").live('click', function(){
        $("#infobox").html( $("#compose").html() );
        window.location.hash = "inbox~compose";
    });
    
    
    
    
    
    
    // PROFILE EDITING:::
    
    $(".editarea p").each(function(){
        //alert();
        $(this).attr('contenteditable', 'true');
    })
    
    $(".editarea .oneline").keypress(function(event){
        return event.which != 13;
    });
    /*
    if (!options.newlinesEnabled){
		// Prevents user from adding newlines to headers, links, etc.
		editable.keypress(function(event){
			// event is cancelled if enter is pressed
			return event.which != 13;
		});
	}
    */
    
    
    
    $(".editarea .submit").click(function(){
        var token = $(".editarea").attr('data-token');
        alert(token);
        return false;
    });
    
    
    
    
    
    
    
    
    
    
    // END PROFILE EDITING
    
    
    
    
    
    
    
    
    
    
    
    
    
    // Handles the "floating" right column.
    
    var floatTarget = $("#comm_right");
    function floatCheck(){
        if (getCurrentPosition() > 64){
            floatTarget.addClass('fixed');
        } else {
            floatTarget.removeClass('fixed');
        }
    }
    
    // Event handler for scroll action.
    $(document).scroll(function(){
        floatCheck();
    });
    
    // End handling of the "floating" right column.
    
    // Ricky thinks this is dead code on Monday June 21st, 2010.
    // $("#wresults ul li div span").live('click', function(){
    //         if ( $(this).siblings(".replies").is(":visible") ){
    //             $(this).siblings(".replies").hide();
    //         } else {
    //             $(".replies").hide();
    //             $(this).siblings(".replies").show();
    //         }
    //     });
    
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
        
        if ( $(this).siblings("form").is(":visible") ) {
            $(this).siblings("form, div.message").hide();
        } else {
            $(this).siblings("div.message").hide();
            
            // we need some autocomplete going on here
            
            $(this).siblings("form").show();
        }
        
    });
    
    // Solid space for a debug function:
    $("#community_name").click(function(event){
        alert( $("#map").jpCount() );
    });

    // Moving between the wire, inbox, and directory.
    $("#toggles div").click(function(event){
        $("#toggles div").removeClass("mode");      // Adjust tab styling.
        $(this).addClass("mode");
        
        $("#stuff").children().hide();
        $( $(this).attr('data-data') ).show();
        
        $("#infobox span").hide();
        if ( $(this).attr('data-data') == '#w' ) {
            window.location.hash = "wire";          // We're in the wire.
            $("#infobox span.wire").show();
            
            // Set up the wire with default data unless there is already data there.
            
        } else if ( $(this).attr('data-data') == '#i' ){
            window.location.hash = "inbox";         // We're in the inbox.
            $("#infobox span.inbox").show();
        } else {
            window.location.hash = url;             // We're in the directory.            
            $("#infobox span.directory").show();
            directoryChange();
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
    
    // TODO: Idea. Overflow-y none the main div, then have jQuery animate the resizing of the big 'ol box.
    function heightCheck(){
        $("#comm_left").height("100%");
        debug && alert("Calling heightCheck()..." + '\n' + "Left Height: " + $("#comm_left").height() + '\n' + "Right Height: " + $("#comm_right").height());
        if ( $("#comm_right").height() > $("#comm_left").height() ){
            $("#comm_left").height( $("#comm_right").height() );
        }
    }
    
    // Clicking a result in any of the three tabs. Updates infobox and registers autoresize.
    $("#wresults ul li, #iresults ul li, #dresults ul li").live('click', function(){        
        $("#wresults ul li, #iresults ul li, #dresults ul li").removeClass('selected');
        $(this).addClass('selected');
        $("#infobox").html( $(this).attr('data-info') );    // Grab the li's data-info attribute and infobox it.
        $('#infobox textarea').autoResize({
            animateDuration : 300,
            extraSpace : 20
        });
        
        heightCheck();
    });
    
    // Directory. Changing the search narrowing.
    $("ul#narrow li").click(function(){
        choice = $(this).attr('data-choice');       // Grab choice.
        directoryChange();
        $("#left_comm").height("auto");
        floatCheck();
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
    }
    
    $("label.in-field").inFieldLabels({fadeOpacity:0});
        
    //$("label.in-field").inFieldLabels({fadeOpacity:0});
    //$(".replies").hide();
    
    $("a.show_replies").live('click', function(){
        $(this).siblings(".replies").slideToggle(300);
        return false;
    });
    
    // Initial page setup:
    // This WILL be generalized into a "updatedHash" function.
    if (window.location.hash == "#wire"){
        $("#wireButton").click();
    } else if (window.location.hash.indexOf("#directory") != -1){        
        //url = window.location.hash.slice(1);    // Takes everything after first character. Therefore, it drops "#".
        $("#directoryButton").click();
    } else if (window.location.hash.indexOf("#inbox") != -1)
        $("#inboxButton").click();
    else {
        window.location.hash = "#wire";
        $("#wireButton").click();
    }
    
    $(window).bind('hashchange', function () {
        var url = window.location.hash.slice(1);
        
        var pieces = url.split('~');
        if (pieces.length > 1){
            url = pieces[0];
            action = pieces[1];
            alert(url + " " + action);
        }

        if (url == "inbox" && action == "compose"){
            $("#i .newthread").click();
        }
        
        if (lasturl == url) return;
        lasturl = url;
        
        debug && alert(url);
        $.ajax({
            url: url,
            dataType: 'script',
            type: "GET",
            beforeSend: function (xhr) {
                debug && alert("before");
            },
            success: function (data, status, xhr) {
                debug && alert("success");
                // alert(data);
                // alert(status);
                // alert(xhr);
                
    //            if ( $("#map").jpCount() > 0 ){
                    $("#map").show();
      //          } else {
          //          $("#map").hide();
        //        }
                
            },
            complete: function (xhr) {
                floatCheck();
                heightCheck();
            },
            error: function (xhr, status, error) {
                debug && alert(error);
            }
        });
        
    });
    
    // Initial page load.
    if (window.location.hash) {
        $(window).trigger('hashchange');
    }

});
