$(document).ready(function(){	
	var sidebar = $('#sections_picker');
	var top = sidebar.offset().top;
	var main;
	$(window).resize(function (event){
		var ypos = $(this).scrollTop();
		main = $('#main').offset().left;
		main += $('#main').width();
		main -= sidebar.width();
		main += 45;
	  if(ypos <= 1952){
		if (ypos+40 >= top) {
            sidebar.css({position: "fixed", left: main, top: "30px"});
		}
        else{
            sidebar.css({position: "absolute", left: "", top: "30px"});
        }
      }
      else{
		sidebar.css({position: "absolute", top: "1802px", left:""})
	  }	
	});
	$(window).scroll(function (event) {
		var ypos = $(this).scrollTop();
		main = $('#main').offset().left;
		main += $('#main').width();
		main -= sidebar.width();
		main += 45;
	  if(ypos <= 1952){
		if (ypos+40 >= top) {
            sidebar.css({position: "fixed", left: main, top: "30px"});
		}
        else{
            sidebar.css({position: "absolute", left: "", top: "30px"});
        }
      }
      else{
		sidebar.css({position: "absolute", top: "1802px", left:""})
	  }
	});

	$.localScroll();
	

});