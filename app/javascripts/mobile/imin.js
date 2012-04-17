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

    events: {
                "click #in":function(e) {
                    var rec = this.model;
                    var url = rec.get("links").checkins;
                    $.postJSON({
                        url: url,
                        data: {},
                        success: function() {
                            var WriteNoteView = new WriteNoteView({el:$('top'),model:rec});
                            WriteNoteView.render();
                        },
                        error: function() {
                                   //console.log("There was an error checking in!");
                               }
                    });
                }
            }
});

