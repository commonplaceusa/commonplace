
OrganizerApp.FilePicker = CommonPlace.View.extend({

  template: "organizer_app.file-picker",

  events: {
    "click .pick-resident": "onClickFile",
    "click .cb": "toggle",
    "click #prev": "previous",
    "click #next": "next",
    "click #filter": "filterUsers",
    "click #filter-order" :"filterUsers",
    "click #filter-button": "filter",
    "click .tag-filter": "cycleFilter",
    "click #check-all": "checkall",
    "click #add-tag" : "addTag",
    "click #map-button": "showMapView",
    "click #new-resident": "addResident",
    "click #todo-list": "gotoTodo",
    "click #interest-picker": "interestPicker",
    "click #statistics-charts": "newCharts"
    //"click #filter-tags": "addNewselect"
    //"click #new-street" : "addStreet"
  },

  addNewselect: function(){

    var select=this.$(".multiselect").clone();
    alert("!");
    //this.$('span[name=tcol1]').append();
    this.$("#new-selects").append(select);
    //alert("!!");
  },

  initialize: function() {
    checklist = [];
    all_check = false;
  },

  onClickFile: function(e) {
    e.preventDefault();
    //console.log($(e.currentTarget));
    this.options.fileViewer.show($(e.currentTarget).data('model'), this.options.community, this.collection,this);
  },

  previous: function() {
    if(page <= 1)
      return;

    --page;

    all_check = false;
    var params = {
      "page": page,
      "per": per
    };
    this.collection.fetch({
      data: params,
      success: _.bind(this.afterRender, this)
    });
  },

  next: function() {
    if(this.amount() < per)
      return;

    ++page;

    all_check = false;
    var params = {
      "page": page,
      "per": per
    };
    this.collection.fetch({
      data: params,
      success: _.bind(this.afterRender, this)
    });
  },

  checkall: function(e) {
    all_check = !all_check;
    _.map(this.$('.cb'), function(box) {
      c = this.$(box).data('model').getId();
      checklist[c] = all_check;
    }, this);
    this.render();
  },

  // This seems like not the right way to implement checkboxes...=|
  toggle: function(e) {

    c = this.$(e.currentTarget).data('model').getId();
    if(typeof checklist[c] === "undefined")
      checklist[c] = false;

    checklist[c] = !checklist[c];
    this.render();
  },

  addTag: function() {
    var tag = this.$("#tag-list option:selected").val();

    if(tag == "")
      return;

    var i = 0;
    var arr = [];
    _.map(this.collection.models, _.bind(function(model) {
      if(checklist[model.getId()]) {

        arr[i] = model.getId();
        ++i;
      }
    }, this));

    $.post(this.collection.url()+"/tags", {tags: tag, file_id: arr}).success(function() { location.reload() });
  },

  gotoTodo: function (e) {
    new OrganizerApp.TodoList({el: $('#file-viewer'), community: this.options.community,  collection: this.collection, filePicker: this}).render();
  },

  addResident: function(e) {
    new OrganizerApp.AddResident({el: $('#file-viewer'), collection: this.collection, filePicker: this}).render();
  },
  
  newCharts: function(e) {
    new OrganizerApp.Charts({el: $('#file-viewer'), community: this.options.community, collection: this.collection, filePicker: this}).render();
  },
/*
  addStreet: function(e) {
    new OrganizerApp.AddStreet({el: $('#file-viewer'), collection: this.collection, filePicker: this}).render();
  },
*/
  interestPicker: function(e) {
    new OrganizerApp.InterestPicker({el: $('#file-viewer'), community: this.options.community, collection: this.collection, filePicker: this}).render();
  },

  showMapView: function(e) {
    new OrganizerApp.MapView({el: $('#file-viewer'), collection: this.collection, filePicker: this}).render();
  },

  afterRender: function() {
    $("#check-all").attr("checked", all_check);
//    this.$("select.list").chosen()

    this.$("select.list").chosen().change({}, function() {
      var clickable = $(this).parent("li").children("div").children("ul");
      clickable.click();
    });

    var deferred = $.Deferred();
    deferred.resolve(this.renderList(this.collection.models));  
    //this.$("#amount").text(this.collection.models.length);
    deferred.done(this.produceOrdertags());
  },

  renderList: function(list) {
    
    this.$("#file-picker-list").empty();

    this.$("#file-picker-list").append(
      _.map(list, _.bind(function(model) {
        /*console.log("renderList model: ");
        console.log(model);
        console.log("model url: ", model.url());
        */
        var li = $("<li/>", { text: model.full_name(), data: { model: model } })[0];
        var cb = $("<input/>", { type: "checkbox", checked: checklist[model.getId()], value: model.getId(), data: { model: model } })[0];
        $(cb).addClass("cb");
        $(li).prepend(cb);
        $(li).addClass("pick-resident");
        return li;
      }, this)));
  },

  filter: function() {
    var params = {
      "with": _.map(this.$(".tag-filter[data-state=on]").toArray(), function(e) {
        return $(e).attr("data-tag");
      }).join(","),
      without: _.map(this.$(".tag-filter[data-state=off]").toArray(), function(e) {
        return $(e).attr("data-tag");
      }).join(","),
      query: this.$("#query-input").val()
    };

    this.collection.fetch({
      data: params,
      success: _.bind(this.afterRender, this)
    });
    //this.showMapView();
  },

  tags: function() { possTags = this.options.community.get('resident_tags'); return this.options.community.get('resident_tags'); },

  cycleFilter: function(e) {
    window.foo = this;
    e.preventDefault();
    var state = $(e.currentTarget).attr("data-state");
    var newState = { neutral: "on", on: "off", off: "neutral"}[state];
    $(e.currentTarget).attr("data-state", newState);
  },

  dropdowns: function(){
    //when organizer becomes more should be pulled from database
    var actions=[{val:"Post",tag: JSON.stringify({tag:"post",type:"action"})},
                 {val:"Email",tag: JSON.stringify({tag:"email",type:"action"})},
                 {val:"Reply",tag: JSON.stringify({tag:"reply",type:"action"})},
                 {val:"Be replied",tag: JSON.stringify({tag:"replied",type:"action"})},
                 {val:"Invite",tag: JSON.stringify({tag:"invite",type:"action"})},
                 {val:"Announcement",tag: JSON.stringify({tag:"announcement",type:"action"})},
                 {val:"Event",tag: JSON.stringify({tag:"event",type:"action"})},
                 {val:"Log in",tag: JSON.stringify({tag:"sitevisit",type:"action"})},
                 {val:"News",tag: JSON.stringify({tag:"story",type:"action"})},
                 {val:"Input Method - Leader List",tag: JSON.stringify({tag:"Leader List",type:"input"})},
                 {val:"Non-Leader List",tag: JSON.stringify({tag:"Non-Leader List",type:"input"})},
                 {val:"Potential Feed Owner",tag: JSON.stringify({tag:"Potential Feed Owner",type:"PFO"})},
                 {val:"Non-Potential Feed Owner",tag: JSON.stringify({tag:"Not Yet Potential Feed Owner",type:"PFO"})},
                 {val:"Sector - Cultural",tag: JSON.stringify({tag:"cultural",type:"sector"})},
                 {val:"Sector - Religious",tag: JSON.stringify({tag:"religious",type:"sector"})},
                 {val:"Sector - Civic",tag: JSON.stringify({tag:"civic",type:"sector"})},
                 {val:"Sector - Government",tag: JSON.stringify({tag:"government",type:"sector"})},
                 {val:"Sector - Schools",tag: JSON.stringify({tag:"schools",type:"sector"})},
                 {val:"Type - Leader",tag: JSON.stringify({tag:"leader",type:"type"})},
                 {val:"Type - Neighbor",tag: JSON.stringify({tag:"neighbor",type:"type"})},
                 {val:"Organizer - Chava",tag: JSON.stringify({tag:"Chava",type:"organizer"})},
                 {val:"Organizer - Peter",tag: JSON.stringify({tag:"Peter",type:"organizer"})},
                 {val:"Organizer - Ricky",tag: JSON.stringify({tag:"Ricky",type:"organizer"})}];
    possTags=this.options.community.get('resident_tags');
    _.map(possTags, function(residenttag) {
      actions.push({val:residenttag,tag: JSON.stringify({tag:residenttag,type:"flag"})});
    });
    interests=this.options.community.get('interests');
    for(i=0;i<interests.length;i++){
      actions.push({val:interests[i],tag: JSON.stringify({tag:i,type:"interest"})});
    }
    return actions;
  },

  filterUsers: function(e){
    this.$("#amount").text("Counting");
    var tag=new Array();
    var Search="filter";
    var select = this.$("select[name=filter-tags]");
    var haves = new Array();
    var len = select[0].options.length;

    for(var x = 0; x < len; ++x) {
      if(select[0].options[x].selected) {
        tag.push(select[0].options[x].value);
        haves.push("yes");
      }

      if(select[1].options[x].selected) {
        tag.push(select[1].options[x].value);
        haves.push("no");
      }
    }
    
    //console.log(tag[0]);
    /*
    _.map(this.$("select[name=filter-tags]"), function(select) {
      if(select.value){
        if(!isNaN(select.value)){
          tag.push(interests[select.value]);
          Search="byinterest";
        }
        else{
          tag.push(select.value);
        }
      }
    });
    var haves=new Array();
    _.map(this.$("select[name=haveornot]"), function(select) {
      if(select.value){
        haves.push(select.value);
      }
    });
    */
    
    switch(e.target.id){
      case "filter":
        var params={
          "page": page,
          "per": per,
          "search": Search,
          "have": haves,
          "tag": tag
        };

        this.collection.fetch({
          data: params,
          success: _.bind(this.afterRender, this)
        });

        break;
      case "filter-order":
        var params={
          "page": page,
          "per": per,
          "search": Search,
          "tag": this.$("#order-tags").val(),
          "order": this.$("#order").val(),
          "ids": this.collection.modelIds()
        };
        
        this.collection.fetch({
          data: params,
          success: _.bind(this.afterRender, this)
        });
        //console.log(params["tag"]);
        break;
    }
  },

  filtByinterest: function(interest){
   var params={
          "search": "byinterest",
          "tag": interest
        };

        this.collection.fetch({
          data: params,
          success: _.bind(this.afterRender, this)
        });
  },

  produceOrdertags: function(){
    this.$("#amount").text(this.collection.models.length);
    var obj = this.$("#order-tags").empty();
    _.map(this.collection.commontags(),function(tag){
      //console.log(tag);
      this.$("#order-tags").append('<option value='+tag+'>'+tag+'</option>');
    });
    for(var x = 0; x <this.$("select[name=filter-tags]")[0].length  ; ++x) {
      if(this.$("select[name=filter-tags]")[0].options[x].selected & this.$("select[name=filter-tags]")[0].options[x].text=="News") {
        this.$("#order-tags").append('<option value=story>News</option>');
        break;
      }
    }
   console.log(this.collection.modelIds());
  },

  refreshStory: function(){
    this.options.community.get('new_stories');
  }

});
