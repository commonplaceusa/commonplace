var ProfileHistory = CommonPlace.View.extend({

  template: "main_page.profile-history",

  history: function() {
    var self = this;
    return _.map(this.collection, function(h) {
      return new ProfileHistoryItem({ model: h, name: self.shortName() });
    }); 
  },
  
  shortName: function() { 
    return this.model.get('first_name') || this.model.get('short_name'); 
  },
  
  hasHistory: function() { return _.size(this.collection) !== 0; }
});
