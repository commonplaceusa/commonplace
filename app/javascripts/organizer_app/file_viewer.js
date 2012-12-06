
OrganizerApp.FileViewer = CommonPlace.View.extend({

  template: "organizer_app.viewer",

  events: {
    "submit form#add-phone": "addPhone",
    "submit form#add-organization": "addOrganization",
    "submit form#add-position": "addPosition",
    "submit form#add-notes": "addNotes",
    "submit form#add-address": "addAddress",
    "submit form#add-email": "addEmail",
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
        var li = $("<li/>", { text: model.full_name(), data: { model: model } })[0];
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
    this.$("#log-add").click($.proxy(function() {
      this.model.addLog();
    }, this));
    this.$("#log-date").datepicker();
    this.allactions();
  },

  ifuser: function() {
    return this.model.get("on_commonplace");
  },

  full_name: function() {
    var name = this.model.full_name();
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

  notes: function() {
    var notes = this.model.get('notes');
    if (!notes) {
      return "No notes in our records";
    } else {
      return notes;
    }
  },

  sector: function() {
    var sector = this.model.get('sector');
    if (!sector) {
      return "No sector in our records";
    } else {
      return sector;
    }
  },

  type: function() {
    var type = this.model.get('type');
    if (!type) {
      return "No type in our records";
    } else {
      return type;
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

  notes: function() {
    var notes = this.model.get('notes');
    if (!notes) {
      return "No notes in our records";
    } else {
      return notes;
    }
  },

  sector: function() {
    var sector = this.model.get('sector');
    if (!sector) {
      return "No sector in our records";
    } else {
      return sector;
    }
  },

  type: function() {
    var type = this.model.get('type');
    if (!type) {
      return "No type in our records";
    } else {
      return type;
    }
  },

  inputMethod: function() {
    return this.model.get('input_method');
  },

  organizer: function(){
    return this.model.get('organizer');
  },

  addAddress: function(e) {
    e.preventDefault();
    var address = this.$("#address-text").val();
    if (!address) {
      alert("Please enter a non-empty address.");
    } else {
      this.model.save({address: address}, {success: _.bind(this.render, this)});
    }
  },

  addPhone: function(e) {
    e.preventDefault();
    var newphone = this.$("#phone-text").val();
    if (!newphone) {
      alert("Please enter a non-empty phone number.");
    } else {
      this.model.save({phone: newphone}, {success: _.bind(this.render, this)});
    }
  },

  addOrganization: function(e) {
    e.preventDefault();
    var organization = this.$("#organization-text").val();
    if (!organization) {
      alert("Please enter a non-empty organization.");
    } else {
      this.model.save({organization: organization}, {success: _.bind(this.render, this)});
    }
  },

  addNotes: function(e) {
    e.preventDefault();
    var notes = this.$("#notes-text").val();
    if (!notes) {
      alert("Please enter a non-empty notes.");
    } else {
      this.model.save({notes: notes}, {success: _.bind(this.render, this)});
    }
  },

  addPosition: function(e) {
    e.preventDefault();
    var position = this.$("#position-text").val();
    if (!position) {
      alert("Please enter a non-empty position.");
    } else {
      this.model.save({position: position}, {success: _.bind(this.render, this)});
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

  addEmail: function(e) {
    e.preventDefault();
    var email = this.$("#email-text").val();
    var atpos = email.indexOf("@");
    var dotpos = email.lastIndexOf(".");
    if (atpos<1 || dotpos<atpos+2 || dotpos+2>=email.length) {
      alert("Please enter a valid email address.");
    } else {
      this.model.save({email: email}, {success: _.bind(this.render, this)});
    }
  },

  tags: function() {
    var tags = this.model.get('tags');
    if (tags) {
      return tags
    } else {
      return "No tags in our records yet.";
    }
  },

  stories: function() {
    return this.model.get('stories');
  },

  allactions: function() {
    //this.$("#action-count").empty();
    //this.$("#action-count").append("<p>here</p>");
    if(!this.model.get("on_commonplace")){
      this.$("#action-count").before("Not a user yet<br>");
      this.$("#content").attr("src",this.model.get("community_id")+"/"+this.model.get("id")+"/residenttags");
      //this.$("#action-count").before("<a href=\""+this.model.get("community_id")+"/"+this.model.get("id")+"/residenttags\" target=\"content\" >Tags</a>");
    }
    else{
      this.$("#content").attr("src",this.model.get("community_id")+"/"+this.model.get("user_id")+"/all");
      this.$("#action-count").before("<a href=\""+this.model.get("community_id")+"/"+this.model.get("user_id")+"/all\" target=\"content\" >All</a>  ||  ");
      this.$("#action-count").before("<a href=\""+this.model.get("community_id")+"/"+this.model.get("user_id")+"/email\" target=\"content\" >Emails Sent</a>  ||  ");
      this.$("#action-count").before("<a href=\""+this.model.get("community_id")+"/"+this.model.get("user_id")+"/sitevisit\" target=\"content\" >Log In Time</a>  ||  ");
      this.$("#action-count").before("<a href=\""+this.model.get("community_id")+"/"+this.model.get("user_id")+"/post\" target=\"content\" >Post</a>  ||  ");
      this.$("#action-count").before("<a href=\""+this.model.get("community_id")+"/"+this.model.get("user_id")+"/announcement\" target=\"content\" >Announcement</a>  ||  ");
      this.$("#action-count").before("<a href=\""+this.model.get("community_id")+"/"+this.model.get("user_id")+"/reply\" target=\"content\" >Reply</a>  ||  ");
      this.$("#action-count").before("<a href=\""+this.model.get("community_id")+"/"+this.model.get("user_id")+"/event\" target=\"content\" >Event</a>  ||  ");
      this.$("#action-count").before("<a href=\""+this.model.get("community_id")+"/"+this.model.get("user_id")+"/invite\" target=\"content\" >Invite</a>  ||  ");
      this.$("#action-count").before("<a href=\""+this.model.get("community_id")+"/"+this.model.get("user_id")+"/tags\" target=\"content\" >Tags</a>");
    }

  },

  possibleTags: function() { return possTags; },
  possibleTodos: function() { return possTodos; }

});
