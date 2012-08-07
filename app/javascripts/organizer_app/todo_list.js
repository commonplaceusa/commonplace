OrganizerApp.TodoList = CommonPlace.View.extend({

  template: "organizer_app.todo-list",

  events: {
    "click .cb": "toggle",
    "click #add-tag" : "addTag",
  },

  initialize: function() {
    checklist = [];
    all_check = false;
    models = this.collection.models;
    community = this.options.community;
  },

  toggle: function(e) {

    c = this.$(e.currentTarget).data('model').getId();

    if(typeof checklist[c] === "undefined")
      checklist[c] = false;

    checklist[c] = !checklist[c];

    console.log("toggle");
    console.log(c);
    console.log(checklist[c]);
    this.render();
  },

  addTag: function() {
    var tag = this.$("#tag-listing option:selected").val();

    if(tag == "")
      return;

    var i = 0;
    var arr = [];
    _.map(models, _.bind(function(model) {
      if(checklist[model.getId()]) {
        console.log(model);

        arr[i] = model.getId();
        ++i;
        //model.addTag(tag, _.bind(this.render, this));
      }

      $.post(this.collection.url()+"/tags", {tags: tag, file_id: arr}).success(function() { location.reload() });
    }, this));
  },

  afterRender: function() {
    this.$("select.listing").chosen();
    /*
    this.$("select.listing").chosen().change({}, function() {
      var clickable = $(this).parent("li").children("div").children("ul");
      clickable.click();
    });
    */

    _.each(this.$(".todo-specific"), function(list) {
      var value = $(list).attr('value');
      var profiles = _.filter(models, function(model) {
        todo = model.get('todos');
        return $.inArray(value, todo) > -1;
      });

      $(list).empty();
      $(list).append(
        _.map(profiles, function(model) {
          var name = model.full_name();
          var email = model.email();
          var phone = model.phone();

          if(email == null) {
            email = "No email";
          }

          if(phone == null) {
            phone = "No phone";
          }

          var info = name + " | " + email + " | "+phone;

          var li = $("<li/>",{ text: info, data: { model: model } })[0];
          var cb = $("<input/>", { type: "checkbox", checked: checklist[model.getId()], value: model.getId(), data: { model: model } })[0];
          $(cb).addClass("cb");
          $(li).prepend(cb);

          return li;
        }));
    });
  },

  profiles: function() {
    var todos = possTodos;

    var names = _.map(models, function(model) {
      return model.full_name();
    });

    return names;
  },

  todos: function() {
    possTodos = this.options.community.get('resident_todos');
    return this.options.community.get('resident_todos');
  },

  tags: function() { return this.options.community.get('resident_tags'); },
});
