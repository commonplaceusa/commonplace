

CommonPlace.Event = Backbone.Model.extend({

  monthAbbrevs: ["Jan", "Feb", "Mar", "Apr", "May", "Jun",
                 "Jul", "Aug", "Sept", "Oct", "Nov", "Dec"],

  initialize: function(attrs, options) {
    this.collection || (this.collection = options.collection);
    this.community = this.collection.community;
    this.replies = new CommonPlace.Replies(this.get('replies'), {repliable: this});
  },

  url: function() { return this.id ? "api/events/" + this.id : "/api/events"; },
  
  date: function() {
    var m = this.get("occurs_on").match(/(\d{4})-(\d{2})-(\d{2})T(\d{2}):(\d{2}):(\d{2})Z/);
    return new Date(m[1],m[2] - 1, m[3]);
  },

  abbrev_month_name: function() {
    return this.monthAbbrevs[this.date().getMonth()];
  },

  day_of_month: function() {
    return this.date().getDate();
  }
  
});

CommonPlace.Events = Backbone.Collection.extend({
  model: CommonPlace.Event,

  initialize: function(models, options) {
    this.community = options.community;
    return this;
  },

  comparator: function(model) { return CommonPlace.parseDate(model.get("occurs_on")); },

  url: function() {
    return "/api/communities/" + this.community.id + "/events";
  }
});