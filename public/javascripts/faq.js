1
2
3
4
5
6
7
8
9
10
11
12
13
14
15
16
17
18
19
20
21
22
23
24
25
26
27
28
29
30
31
32
33
34
35
36
37
38
39
40
41
42
43
44
45
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