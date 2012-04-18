var ImInView = CommonPlace.View.extend({
    template: "mobile.imin",

    user: function() {
        return window.full_name;
    },

    notes: function() {
               return this.model.get('notes');
           },

    title: function() {
                return this.model.get('title');
            },

    venue: function() {
               return this.model.get('venue');
           },

    events: {
                "click #in":function(e) {
                    var rec = this.model;
                    var url = rec.get("links").checkins;
                    $.postJSON({
                        url: "/api"+url,
                        data: {},
                        success: function() {
                            console.log("I'm in!");
                            var writeNoteView = new WriteNoteView({el:$('#top'),model:rec});
                            writeNoteView.render();
                        },
                        error: function() {
                                   //console.log("There was an error checking in!");
                               }
                    });
                }
            }
});

