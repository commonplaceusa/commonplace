var RecommendationView = CommonPlace.View.extend({
    template: "mobile.recommendations",

    recommendations: function() {
        return this.collection.toJSON();
    },

    events: {
                "click .item":function(e) {
                    var id = $(e.currentTarget).data('id');
                    var rec = this.collection.get(id);
                    var ImInView = new ImInView({el:$('#main'), model:rec});
                    ImInView.render();
            }
});

