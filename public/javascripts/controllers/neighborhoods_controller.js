
$.sammy("body")

  .get("#/neighborhood/people", function(c) {
    $.get("/neighborhood/people", function(r) {
      merge(r, $('body'));
    });
  })

  .get("#/neighborhood/posts", function(c) {
    $.get("/neighborhood/posts", function(r) {
      merge(r, $('body'));
    });
  })