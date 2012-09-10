var WriteNoteView = CommonPlace.View.extend({
    template: "mobile.write_note",

    events: {
        "submit form":function(e) {
                e.preventDefault();
                $("#progress").show();
                var rec = this.model;
                var url = rec.get("links").notes;
                var message = $("textarea#message").val();
                $.postJSON({
                    url: "/api"+url,
                    data: { body: message },
                    success: function() {
                        $("#progress").hide();
                        $("textarea#message").val('');
                        $("#write_note_form").hide();
                        $("#thanks").fadeIn(400).delay(3000).fadeOut(800);
                        $("#write_note_form").show();
                    },
                    error: function() {
                           }
                });
        }
    }
});
