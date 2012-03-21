var Recommendation = CommonPlace.Model.extend({});

var Recommendations = CommonPlace.Collection.extend({
    url: function() { return "/api/account/recommendation"; },
    model: Recommendation
});
