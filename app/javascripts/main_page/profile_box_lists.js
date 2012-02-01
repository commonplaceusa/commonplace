var ProfileBoxLists = CommonPlace.View.extend({
  id: "profile-box-lists",
  
  initialize: function() {
    
    this.lists = {
      "users": CommonPlace.account.featuredUsers,
      "feeds": CommonPlace.community.featuredFeeds,
      "groups": CommonPlace.community.groups,
      "account": CommonPlace.account.featuredUsers
    };
    
    var self = this;
    this.nextPageTrigger();
    this.page = 0;
    
    this.$("#profile-box-results").scroll(function() {
      if ($(this).scrollTop() > ((5 * this.scrollHeight) / 9)) {
        self.nextPageThrottled();
      }
    });
  },

  showList: function(list_name, options) {
    this.clearSearch();
    this.$("#profile-box-failed-search").hide();
    this.page = 0;
    var list = this.lists[list_name];
    if (this.currentList !== list) {
      this.currentList = list;
      this.fetchAndRenderCurrentList(options);
    }
  },

  showSearch: function(search_term, options) {
    this.$("#profile-box-failed-search").hide();
    this.page = 0;
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
    
    var $results = this.$("#profile-box-results ul");
    if (!options || !options.nextPage) {
      $results.empty();
    }
    
    $results.append(_.pluck(views, "el"));
    
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
  },
  
  nextPageTrigger: function() {
    var self = this;
    this.nextPageThrottled = _.once(function() {
      self.nextPage();
    });
  },
  
  nextPage: function() {
    if (this.currentList.length < 25) { return; }
    this.page++;
    this.currentList.fetch({
      data: {
        query: this.currentQuery,
        page: this.page
      },
      success: _.bind(function() {
        this.renderCurrentList({ nextPage: true });
        this.nextPageTrigger();
      }, this),
      error: _.bind(function() {
        this.nextPageTrigger();
      }, this)
    });
  }
  
});
