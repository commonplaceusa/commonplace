var ImInView = CommonPlace.View.extend({
    template: "mobile.imin",

    user: function() {
        return window.full_name;
    },

    feed: function() {
        return this.model.feed.toJSON();
    },

    title: function() {
                return this.model.title;
            },

    venue: function() {
               return this.model.venue;
           },

    events: "click #in":function(e) {
                // create new model
                // write to database
                var rec = this.model;
                var WriteNoteView = new WriteNoteView({el:$('top'),model:rec});
                WriteNoteView.render();
            }
});

