var EventInfoBox = InfoBox.extend({
  template: "info_boxes/event-info-box",
  className: "event",

  name: function() { return this.model.get("title"); },

  about: function() { return this.model.get("body"); },

  tags: function() { return this.model.get("tags"); },
  
  startsAt: function() { return this.model.get("starts_at"); },
  
  endsAt: function() { return this.model.get("ends_at"); },

  venue: function() { return this.model.get("venue"); },

  address: function() { return this.model.get("address"); },

  abbrevMonth: function() { return this.monthAbbrevs[this.date().getMonth()]; },

  dayOfMonth: function() { return this.date().getDate(); },

  monthAbbrevs: ["Jan", "Feb", "Mar", "Apr", "May", "Jun",
                 "Jul", "Aug", "Sept", "Oct", "Nov", "Dec"],

  date: function() {
    var m = this.model.get("occurs_on").match(/(\d{4})-(\d{2})-(\d{2})T(\d{2}):(\d{2}):(\d{2})Z/);
    return new Date(m[1],m[2] - 1, m[3]);
  }
});