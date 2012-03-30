var WriteNoteView = CommonPlace.View.extend({
    template: "mobile.write_note",

    events: "submit form":function(e) {
                e.preventDefault();
                $("#progress").show();
                // create note model
                // write to database
                // what to do after note is submitted??
                $("#progress").hide();
                $("#write_note_form").hide();
                $("#thanks").fadeIn(400).delay(3000).fadeOut(800);
                $("#write_note_form").show();
    }
});
