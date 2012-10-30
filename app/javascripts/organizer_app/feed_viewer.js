OrganizerApp.FeedViewer = CommonPlace.View.extend({

  template: "organizer_app.feed-viewer",

  events: {
    "click #edit-resident":"editResident",
    "click .interests": "filterByinterest"
  },

  editResident: function(){
    new OrganizerApp.AddResident({el: $('#file-viewer'), model: this.model, fileViewer: this, edit:true}).render();
  },

  onClickFile: function(e) {
    e.preventDefault();
    this.show($(e.currentTarget).data('model'), this.community, this.collection);
  },

  interests: function(){
    return this.model.get('interests');
  },

  filterByinterest: function(e){
    this.filePicker.filtByinterest($(e.currentTarget).text());
  },

  renderList: function(list) {
    this.$("#user-picker-list").empty();
    this.$("#user-picker-list").append(
      _.map(list, _.bind(function(model) {
        var li = $("<li/>", { text: model.name(), data: { model: model } })[0];
        $(li).addClass("pick-user");
        return li;
      }, this)));
  },

  show: function(model,community,collection,filePicker) {
    this.model = model;
    this.filePicker=filePicker;
    this.community = community;
    this.collection=collection;
    this.render();
  },

  ifuser: function() {
    return this.model.get("on_commonplace");
  },

  subscribers_count: function() {
    return this.model.count();
  },

  name: function() {
    var name = this.model.name();
    if (name === undefined) {
      return "No name";
    } else {
      return name;
    }
  },

  address: function() {
    var address = this.model.get('address');
    if (!address) {
      return "No address in our records";
    } else {
      return address;
    }
  },

  phone: function() {
    var phone = this.model.get('phone');
    if (!phone) {
      return "No phone in our records";
    } else {
      return phone;
    }
  },

  organization: function() {
    var organization = this.model.get('organization');
    if (!organization) {
      return "No organization in our records";
    } else {
      return organization;
    }
  },

  position: function() {
    var position = this.model.get('position');
    if (!position) {
      return "No position in our records";
    } else {
      return position;
    }
  },

  phone: function() {
    var phone = this.model.get('phone');
    if (!phone) {
      return "No phone in our records";
    } else {
      return phone;
    }
  },

  email: function() {
    var email = this.model.get('email');
    if (!email) {
      return "No email in our records";
    } else {
      return email
    }
  },

  possibleTags: function() { return possTags; },
  possibleTodos: function() { return possTodos; }
});
