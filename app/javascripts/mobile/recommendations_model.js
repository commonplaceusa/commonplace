var Recommendation = Backbone.Model.extend({});

var Recommendations = Backbone.Collection.extend({
    url: function() { return "/api/account/recommendations"; },
    model: Recommendation
});
