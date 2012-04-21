
var PostBox = CommonPlace.View.extend({
  template: "main_page.post-box",
  id: "post-box",
  
  events: {
    "click .navigation li": "clickTab"
  },
  
  afterRender: function() {
    this.temp = {};
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
      var $title = this.$("[name=title]");
      var $body = this.$("[name=body], [name=about]");
      this.temp = {};
      if ($title.attr('placeholder') != $title.val()) {
        this.temp.title = $title.val();
      }
      if ($body.attr('placeholder') != $body.val()) {
        this.temp.body = $body.val();
      }
    }
    this.showTab(tab, e);
  },

  absolutePosition: function(element) {
    var curleft = curtop = 0;
    if (element.offsetParent) {
      do {
        curleft += element.offsetLeft;
        curtop += element.offsetTop;
      } while (element = element.offsetParent);
    }
    return [curleft, curtop];
  },
  
  showTab: function(tab, e) {
    var view;
    $("#invalid_post_tooltip").hide();
    
    this.$("li.current").removeClass("current");
    
    if (tab == "announcement") { tab = "publicity"; }
    if (tab == "group_post") { tab = "group"; }
    
    this.$("li." + tab).addClass("current");
    view = this.tabs(tab);
    
    view.render();
    this.$("form").replaceWith(view.el);
    

    if (this.temp) {
      this.$("form input[name=title]").val(this.temp.title);
      this.$("form textarea[name=body]").val(this.temp.body);
      this.$("form textarea[name=about]").val(this.temp.body);
    }
    this.$("[placeholder]").placeholder();    
    CommonPlace.layout.reset();
    
    this.showWire(tab);

    if (view.$el.height() + this.absolutePosition(view.el)[1] > $(window).height()) {
      // Make the position fixed
      var newHeight = $(window).height() - this.absolutePosition(view.el)[1] - 20;
      view.$el.css("height", "" + newHeight + "px");
      view.$el.css("width", view.$el.width() + 25 + "px");
      view.$el.css("overflow-y", "scroll");
      view.$el.css("overflow-x", "hidden");
    }

    if (view.onFormFocus) { view.onFormFocus(); }
  },
  
  tabs: function(tab) {
    var view;
    var constant = {
      nothing: function() { return new PostForm(); },
      event: function() { return new EventForm(); },
      post: function() { return new PostForm({
        category: "neighborhood",
        template: "main_page.forms.post-neighborhood-form"
      }); },
      publicity: function() { return new PostForm({
        category: "publicity",
        template: "main_page.forms.post-publicity-form"
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
    };
    
    if (!constant[tab]) {
      view = new AnnouncementForm({
        feed_id: tab.split("-").pop()
      });
    } else { view = constant[tab](); }
    
    return view;
  },
  
  groups: function() {
    return CommonPlace.community.get("groups");
  },
  
  showWire: function(tab) {
    if (tab != "nothing") {
      if (tab.search("feed") > -1) { tab = "announcements"; }
      var wire = $(".resources .sub-navigation." + tab);
      if (wire.length) {
        var offset = wire.offset().top;
        $(window).scrollTo(offset - parseInt($("#community-resources .sticky").css("top")));
      }
    }
  },
  
  feeds: function() { return CommonPlace.account.get("feeds"); }
  
  
});

