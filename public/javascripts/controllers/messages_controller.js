
$.sammy('body')

  .get('#/:messagable_type/:messagable_id/messages/new', function(c) {
    $.get(c.path.slice(1), function(r) {
      merge(r, $('body'));
    }, "html");
  })

  .post('/users/:user_id/messages', function(c) {
    $.post(c.path, c.params, function(r) {
      merge(r, $('body'));
    }, "html");
  })