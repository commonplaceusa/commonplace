OrganizerApp.TodoList = CommonPlace.View.extend({

  template: "organizer_app.todo-list",

  events: {
    "click .cb": "toggle",
    "click .checkall": "checkall",
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

    /*
    console.log("toggle");
    console.log(c);
    console.log(checklist[c]);
    */
    this.render();
  },

  checkall: function(e){
    var name=e.target.id;
    _.each(this.$("input[name='"+name+"[]']"),function(checkbox){
      var id=checkbox.value;
      if(typeof checklist[id] === "undefined")
        checklist[id] = false;
      checklist[id] = !checklist[id];
    });

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
        //console.log(model);
        arr[i] = model.getId();
        ++i;
        //model.addTag(tag, _.bind(this.render, this));
      }
    }, this));
    $.post(this.collection.url()+"/tags", {tags: tag, file_id: arr}).success(function() { location.reload() });
  },

  afterRender: function() {
    this.$("select.listing").chosen();
    var deferred = $.Deferred();
    deferred.resolve(
    _.each(this.$(".todo-specific"), function(list) {
      var value = $(list).attr('value');
      var profiles = _.filter(models, function(model) {
        todo = model.get('todos');
        return $.inArray(value, todo) > -1;
      });
      if(profiles.length>0){
	      $(list).empty();
	      var tbody=  $("<tbody/>");
	      var thead=$("<thead><tr><th><input type=checkbox class=checkall id=\""+value+"\"/></th> <th>Name</th> <th>Email</th> <th>Phone</th></tr> </thead>");
	      $(list).append(thead);
	      var trs=
		_.map(profiles, _.bind(function(model) {
		  var name = model.full_name();
		  var email = model.email();
		  var phone = model.phone();

		  if(email == null) {
		    email = "No email";
		  }

		  if(phone == null) {
		    phone = "No phone";
		  }

		  //var info = name + " | " + email + " | "+phone;

		  //var li = $("<li/>",{ text: info, data: { model: model } })[0];
		  var cb = $("<input/>", { type: "checkbox", name: value+"[]", checked: checklist[model.getId()], value: model.getId(), data: { model: model } })[0];
		  $(cb).addClass("cb");
		  var td=$("<td/>");
		  $(td).append(cb);
		  var tr=$("<tr/>");
		  $(tr).append(td);
		  $(tr).append("<td>"+name+"</td><td>"+email+"</td><td>"+phone+"</td>");

		  //$(tr).prepend(cb)
		  //$(li).prepend(cb);

		  return tr;
		}, this));
	      _.each(trs,function(tr){$(tbody).append(tr);});
	      $(list).append(tbody);
	    }

    else{
      $("a[name='"+value+"']").remove();
      $("table[name='"+value+"']").remove();
    }
    }));
	deferred.done(this.$("table.todo-specific").dataTable({
                                                 "bPaginate": false
                                                  }));

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
