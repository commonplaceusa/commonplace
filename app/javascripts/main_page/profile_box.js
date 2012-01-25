var ProfileBox = CommonPlace.View.extend({
  template: "main_page.profile-box",
  id: "profile-box",

  initialize: function(options) {
    this.profileDisplayer = options.profileDisplayer;
  },

  afterRender: function() {
    this.lists = new ProfileBoxLists({ 
      el: this.$("#profile-box-lists"), 
      showProfile: _.bind(this.profileDisplayer.show, this.profileDisplayer)
    });

    this.$("#profile-box-profile").replaceWith(this.profileDisplayer.el);
    this.profileDisplayer.render();
    this.lists.showList("account");
  },

  events: {
    "click .filters a": "switchFilter",
    "click .remove-search": "removeSearch",
    "keyup input.search": "search"
  },

  switchFilter: function(e) {
    e.preventDefault();

    var schema = $(e.target).attr("href").split("#")[1];
    
    if (schema == "account") {
      this.lists.showList(schema);
      this.profileDisplayer.show(CommonPlace.account);
    } else {
      this.lists.showList(schema, { showProfile: true });
    }

    this.$(".filters a").removeClass("current");
    $(e.target).addClass("current");
    this.lists.clearSearch();
  },

  search: _.debounce(function() {
    var search_term = this.$("#profile-box-search input.search").val();
    if (search_term === "") {
      this.removeSearch()
    } else {
      this.lists.showSearch(search_term, { showProfile: true });
      this.$(".filters a").removeClass("current");
    }
  }, 500),

  removeSearch: function() { 
    this.lists.clearSearch(); 
    this.$(".filters a.account-filter").click() 
  }
  

});
