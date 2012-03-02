var ImInView = CommonPlace.View.extend({
    template: "mobile.imin",

    feed: function() {
        return this.model.feed.toJSON();
    },

    events: "click #in":function(e) {
                // create new model
                // write to database
                var rec = this.model;
                var WriteNoteView = new WriteNoteView({el:$('top'),model:rec});
                WriteNoteView.render();
            }
});

