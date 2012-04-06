var Recommendation = CommonPlace.Model.extend({});

var Recommendations = BackBone.Collection.extend({
    url: function() { return "/api/account/recommendation"; },
    model: Recommendation
});
