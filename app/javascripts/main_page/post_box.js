
var PostBox = CommonPlace.View.extend({
  template: "main_page.post-box",
  id: "post-box",
  
  events: {
    "click .navigation li": "clickTab"
  },
  
  afterRender: function() {
    this.temp = {}
    this.showTab("nothing");
  },
  
  clickTab: function(e) {
    e.preventDefault();
    // DETERMINE WHAT TO DO WITH URLS WHEN WE CLICK
    this.switchTab($(e.target).attr("data-tab"), e);
    $("#first_post_tooltip").hide();
  },
  
  switchTab: function(tab, e) {
    if (this.$("form input").length) {
      this.temp = {
        title: this.$("form input[name=title]").val(),
        body: this.$("form textarea[name=body]").val() ||
              this.$("form textarea[name=about]").val()
      }
    }
    this.showTab(tab, e);
  },
  
  showTab: function(tab, e) {
    var view;
    
    this.$("li.current").removeClass("current");
    
    if (tab == "announcement") { tab = "publicity"; }
    if (tab == "group_post") { tab = "group"; }
    
    this.$("li." + tab).addClass("current");
    view = this.tabs[tab](this);
    
    view.render();
    this.$("form").replaceWith(view.el);
    
    if (this.temp) {
      this.$("form input[name=title]").val(this.temp.title);
      this.$("form textarea[name=body]").val(this.temp.body);
      this.$("form textarea[name=about]").val(this.temp.body);
    }
    
    CommonPlace.layout.reset();
    
    this.showWire(tab);
  },
  
  tabs: {
    nothing: function() { return new PostForm(); },
    event: function() { return new EventForm(); },
    post: function() { return new PostForm({
      category: "neighborhood",
      template: "main_page.forms.post-neighborhood-form"
    }); },
    publicity: function() { return new PostForm({
      category: "publicity",
      template: "main_page.forms.post-publicity-form",
    }); },
    offers: function() { return new PostForm({
      category: "offers",
      template: "main_page.forms.post-offer-form"
    }); },
    help: function() { return new PostForm({
      category: "help",
      template: "main_page.forms.post-help-form"
    }); },
    other: function() { return new PostForm({
      category: "other",
      template: "main_page.forms.post-form"
    }); },
    group: function() { return new GroupPostForm(); },
    meetups: function() { return new PostForm({
      category: "meetups",
      template: "main_page.forms.post-meetup-form"
    }); }
  },
  
  groups: function() {
    return CommonPlace.community.get("groups");
  },
  
  showWire: function(tab) {
    if (tab != "nothing") {
      var wire = $(".resources .sub-navigation." + tab);
      if (wire.length) {
        var offset = wire.offset().top;
        $(window).scrollTo(offset - parseInt($("#community-resources .sticky").css("top")));
      }
    }
  }
  
  
});

