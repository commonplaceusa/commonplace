var choice;
var search;
var url;

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
            window.location.hash = "wire";          // We're in the wire.
            
            // Set up the wire with default data unless there is already data there.
            
        } else {
            window.location.hash = "directory";     // We're in the directory.
            $.get('directory', function(data) {
                //$('.result').html(data);
                
                //alert(data);
                
                $("#dresults").html(data);
            });
            
            
        }
        
        event.preventDefault();
        return false;   // remove this
        
    });
    
    function keyCheck(e) {
        switch(e.keyCode) {	
    		case 13:    // return
    			alert('hi');
    			directoryChange();
    			break;
    		default:
    			break;	
    	}
    }
    
    // add style for when that form has focus...
    $("#d .intro input").keyup(keyCheck);
    
    $("#dresults ul li").live('click', function(){
        $("#infobox").html( $(this).attr('data-info') );    // Grab the li's data-info attribute and infobox it.
    });
    
    $("ul#narrow li").click(function(){
        choice = $(this).attr('data-choice');       // Grab choice,
        
        directoryChange();
        // Fire off some AJAX here.
        
        if (choice == "all"){
            $(this).parent().siblings(".alphabeta").fadeOut();
        } else {
            $(this).parent().siblings(".alphabeta").fadeIn();
        }
        
        $(this).siblings().removeClass("selected");
        $(this).addClass("selected");
    });
    
    function directoryChange() {
        search = $("#d .intro input").val();   // search term,
        url = 'directory/' + choice;                // construct a url.
        if (search) url += '/' + search;
        alert(url);
        
        $.get(url, function(data) {
            $("#dresults").html(data);
        });
    }
    
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
