var EventFormView = FormView.extend({
  afterRender: function() {
    this.modal.render();
    this.$("input.date").datepicker({dateFormat: 'yy-mm-dd'});
    this.$("select.time").dropkick();
  },

  save: function(callback) {
    var self = this;
    this.model.save({
      title: this.$("[name=title]").val(),
      body: this.$("[name=body]").val(),
      occurs_at: this.$("[name=date]").val(),
      starts_at: this.$("[name=start]").val(),
      ends_at: this.$("[name=end]").val(),
      venue: this.$("[name=venue]").val(),
      address: this.$("[name=address]").val()
    }, {
      success: callback,
      error: function(attribs, response) { self.showError(response); }
    });
  },
  
  showError: function(response) {
    this.$(".error").text(response.responseText);
    this.$(".error").show();
  },

  remove: function(callback) {
    this.model.destroy({ success: callback });
  },

  title: function() {
    return this.model.get("title");
  },

  body: function() {
    return this.model.get("body");
  },

  date: function() {
    return this.model.get("occurs_at").split("T")[0];
  },

  venue: function() {
    return this.model.get("venue");
  },

  address: function() {
    return this.model.get("address");
  },

  time_values: function() {
    var start_value = (this.model.get("starts_at") || "").replace(" ", "");
    var end_value = (this.model.get("ends_at") || "").replace(" ", "");
    var list = _.flatten(_.map(["AM", "PM"],
      function(half) {
        return  _.map(_.range(1,13),
        function(hour) {
          return _.map(["00", "30"],
          function(minute) {
            return String(hour) + ":" + minute + " " + half;
          });
        });
      })
    );
    var result = [];
    _.each(list, function(time) {
      var obj = {
        ".": time,
        "is_start": (time.replace(" ","").toLowerCase() == start_value),
        "is_end": (time.replace(" ","").toLowerCase() == end_value)
      };
      result.push(obj);
    });
    return result;
  }
});


