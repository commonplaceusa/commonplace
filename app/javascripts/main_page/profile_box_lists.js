var ProfileBoxLists = CommonPlace.View.extend({
  id: "profile-box-lists",
  
  initialize: function() {
    
    this.lists = {
      "users": CommonPlace.account.featuredUsers,
      "feeds": CommonPlace.community.featuredFeeds,
      "groups": CommonPlace.community.groups,
      "account": CommonPlace.account.featuredUsers
    };
  },

  showList: function(list_name, options) {
    this.$("#profile-box-failed-search").hide();
    var list = this.lists[list_name];
    if (this.currentList !== list) {
      this.currentList = list;
      this.fetchAndRenderCurrentList(options);
    }
  },

  showSearch: function(search_term, options) {
    this.$("#profile-box-failed-search").hide();
    this.currentList = CommonPlace.community.grouplikes;
    this.currentQuery = search_term;
    this.fetchAndRenderCurrentSearch(options);
  },

  clickFirstLI: function() { this.$("li").first().click(); },

  renderCurrentList: function(options) {
    var self = this;
    var views = this.currentList.map(function(item) {
      return new ProfileBoxListItem({ 
        model: item, 
        showProfile: function(profile) { 
          self.options.showProfile(profile, { highlight: self.currentQuery });
        }
      });
    });
    
    _.invoke(views, "render");
    this.$("#profile-box-results ul").empty().append(_.pluck(views, "el"));
    
    if (options && options.showProfile) {
      this.clickFirstLI();
    }
  },

  fetchAndRenderCurrentList: function(options) {
    var _render = _.bind(function() { this.renderCurrentList(options); }, this);
    if (this.currentList.length === 0) {
      this.currentList.fetch({ success: _render });
    } else {
      _render();
    }
  },

  fetchAndRenderCurrentSearch: function(options) {
    CommonPlace.community.grouplikes.fetch({
      data: { query: this.currentQuery },
      success: _.bind(function() { 
        if (this.currentList.length === 0) {
          this.$("#profile-box-failed-search").show();
          this.options.showProfile(new ClientSideModel({ 
            schema: "failed_search",
            id: this.currentQuery,
            query: this.currentQuery
          }));
        } 
        this.renderCurrentList(options); 
      }, this)
    });
  },

  clearSearch: function() { 
    this.$("#profile-box-search input.search").val(""); 
    this.currentQuery = "";
  }
  
});
