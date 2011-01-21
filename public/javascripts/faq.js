$(document).ready(function(){	
	var sidebar = $('#sections_picker');
	var top = sidebar.offset().top;
	$(window).scroll(function (event) {
		var ypos = $(this).scrollTop();
		if (ypos >= top-20) {
        	if(-180+ypos<=1864){
            	sidebar.css({top: (-180+ypos)+"px"});
            }
            else{ 
               	sidebar.css({top: "1864px"});
            }
		}
        else{
            sidebar.css({top: ""});
        }
	});

	$.localScroll();
});