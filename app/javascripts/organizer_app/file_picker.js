
OrganizerApp.FilePicker = CommonPlace.View.extend({

  template: "organizer_app.file-picker",

  events: {
    "click .pick-resident": "onClickFile",
    "click .cb": "toggle",
    "click #prev": "previous",
    "click #next": "next",
    "click #filter": "filterUsers",
    "click #filter-order" :"filterUsers",
    "click #search-button": "search",
    "click .tag-filter": "cycleFilter",
    "click #check-all": "checkall",
    "click #server-tag": "serverAddTag",
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
    total = 0;
    auto_page = 1;
  },

  onClickFile: function(e) {
    e.preventDefault();
    this.options.fileViewer.show($(e.currentTarget).data('model'), this.options.community, this.collection,this);
  },

  previous: function(e) {
    if(page <= 1)
      return;

    --page;
    all_check = false;

    this.filterUsers(e);
  },

  next: function(e) {
    if(this.collection.models.length < per)
      return;

    ++page;
    all_check = false;

    this.filterUsers(e);
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

  serverAddTag: function() {
    var add = this.$("#tag-list option:selected").val();
    var all = this.filter();
    var tag = all[0];
    var haves = all[1];

    if(add == "")
      return;

    var params = {
      "add": add,
      "tag": tag,
      "have": haves,
      "per": per,
      "page": auto_page
    }

    //$.post(this.collection.url()+"/tag_all", params).success(_.bind(this.callback, this)).error(function(attr, response) { alert(response) });
    //$.post(this.collection.url()+"/tag_all", params).success(function() { alert("Added tag"); }).error(function(attr, response, error) { alert(error) });
    $.ajax({
      type: 'POST',
      url: this.collection.url()+"/tag_all",
      data: params,
      success: _.bind(this.callback, this),
      error: function(attr, response, error) { alert(error); }
    });
  },

  callback: function(response) {

    total = auto_page * per;
    if(total < response) {
      auto_page += 1;
      this.serverAddTag();
    }
    else {
      auto_page = 1;
      alert("Completed");
    }
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

    $.post(this.collection.url()+"/tags", {tags: tag, file_id: arr}).success(function() { alert("Added tag"); });
  },

  gotoTodo: function (e) {
    $('#file-viewer').unbind();
    $('#file-viewer').empty();
    new OrganizerApp.TodoList({el: $('#file-viewer'), community: this.options.community,  collection: this.collection, filePicker: this}).render();
  },

  addResident: function(e) {
    $('#file-viewer').unbind();
    $('#file-viewer').empty();
    new OrganizerApp.AddResident({el: $('#file-viewer'), collection: this.collection, filePicker: this}).render();
  },

  newCharts: function(e) {
    $('#file-viewer').unbind();
    $('#file-viewer').empty();
    new OrganizerApp.Charts({el: $('#file-viewer'), community: this.options.community, collection: this.collection, filePicker: this}).render();
  },
/*
  addStreet: function(e) {
    new OrganizerApp.AddStreet({el: $('#file-viewer'), collection: this.collection, filePicker: this}).render();
  },
*/
  interestPicker: function(e) {
    $('#file-viewer').unbind();
    $('#file-viewer').empty();
    new OrganizerApp.InterestPicker({el: $('#file-viewer'), community: this.options.community, collection: this.collection, filePicker: this}).render();
  },

  showMapView: function(e) {
    $('#file-viewer').unbind();
    $('#file-viewer').empty();
    new OrganizerApp.MapView({el: $('#file-viewer'), collection: this.collection, filePicker: this}).render();
  },

  afterRender: function() {
    $("#pg_num").text(page);
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
        var li = $("<li/>", { text: model.full_name(), data: { model: model } })[0];
        var cb = $("<input/>", { type: "checkbox", checked: checklist[model.getId()], value: model.getId(), data: { model: model } })[0];
        $(cb).addClass("cb");
        $(li).prepend(cb);
        $(li).addClass("pick-resident");
        return li;
      }, this)));
  },

  search: function() {
    var params = {
      page: page,
      per: per,
      search: "search",
      type: this.$("#query-select option:selected").val(),
      text: this.$("#query-input").val()
    };

    if(params["text"] == null || params["text"].length === 0) {
      return;
    }

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
                 {val:"News",tag: JSON.stringify({tag:"story",type:"action"})}];
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

  filter: function() {
    var tag=new Array();
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

    return [tag, haves];
  },

  filterUsers: function(e){

    this.$("#total").empty();
    this.$("#amount").text("Counting");
    var Search = "filter";
    var all = this.filter();
    var tag = all[0];
    var haves = all[1];

    switch(e.target.id){
      case "filter":
        page = 1;
      case "prev":
      case "next":
        var params={
          "page": page,
          "per": per,
          "search": Search,
          "have": haves,
          "tag": tag,
          "count": true
        };

        $.get(this.collection.url(), params, _.bind(function(response) {
          total = response;

          var params={
            "page": page,
            "per": per,
            "search": Search,
            "have": haves,
            "tag": tag
          };

          this.collection.fetch({
            data: params,
            success: _.bind(this.afterRender, this),
            error: function(attr, response) { alert(response) }
          });
        }, this));

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
          success: _.bind(this.afterRender, this),
          error: function(attr, response) { alert(response) }
        });
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
    this.$("#total").text(total);
    this.$("#amount").text(this.collection.models.length);
    var obj = this.$("#order-tags").empty();
    _.map(this.collection.commontags(),function(tag){
      this.$("#order-tags").append('<option value='+tag+'>'+tag+'</option>');
    });
    for(var x = 0; x <this.$("select[name=filter-tags]")[0].length  ; ++x) {
      if(this.$("select[name=filter-tags]")[0].options[x].selected & this.$("select[name=filter-tags]")[0].options[x].text=="News") {
        this.$("#order-tags").append('<option value=story>News</option>');
        break;
      }
    }
  },

  refreshStory: function(){
    this.options.community.get('new_stories');
  }

});
