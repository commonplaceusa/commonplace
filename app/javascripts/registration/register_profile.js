var RegisterProfileView = CommonPlace.View.extend({
  template: "registration.profile",
  
  events: {
    "click input.continue": "submit"
  },
  
  initialize: function(options) {
    this.data = options.data;
    this.nextPage = options.nextPage;
    this.communityExterior = options.communityExterior;
  },
  
  afterRender: function() {
    this.initReferralQuestions();
    
    this.initAvatarUploader(this.$(".avatar_file_browse"));
    
    this.options.slideIn(this.el);
  },
  
  community_name: function() { return this.communityExterior.name; },
  
  submit: function(e) {
    if (e) { e.preventDefault(); }
    this.data.password = this.$("input[name=password]").val();
    this.data.about = this.$("textarea[name=about]").val();
    
    _.each(["interests", "skills", "goods"], _.bind(function(listname) {
      var list = this.$("select[name=" + listname + "]").val();
      if (!_.isEmpty(list)) { this.data[listname] = list.toString(); }
    }, this));
    
    this.data.referral_source = this.$("select[name=referral_source]").val();
    this.data.referral_metadata = this.$("input[name=referral_metadata]").val();
    
    $.post(
      "/api" + this.communityExterior.links.registration["new"],
      this.data,
      _.bind(function(response) {
        if (response.success == "true" || response.id) {
          CommonPlace.account = new Account(response);
          if (this.$("input[name=avatar_file]").val()) {
            this.avatarUploader.submit();
          } else {
            this.nextPage("feed");
          }
        }
      }, this)
    );
  },
  
  skills: function() { return this.communityExterior.skills; },
  
  interests: function() { return this.communityExterior.interests; },
  
  goods: function() { return this.communityExterior.goods; },
  
  referrers: function() { return this.communityExterior.referral_sources; },
  
  initAvatarUploader: function($el) {
    var self = this;
    this.avatarUploader = new AjaxUpload($el, {
      action: "/api" + this.communityExterior.links.registration.avatar,
      name: 'avatar',
      data: { },
      responseType: 'json',
      autoSubmit: false,
      onChange: function(file, extension){
        self.$("input[name=avatar_file]").val(file);
      },
      onSubmit: function(file, extension) {},
      onComplete: function(file, response) { 
        CommonPlace.account.set(response); 
        self.nextPage("crop");
      }
    });
  },
  
  initReferralQuestions: function() {
    this.$("select[name=referral_source]").bind("change", _.bind(function() {
      var question = {
        "At a table or booth at an event": "What was the event?",
        "In an email": "Who was the email from?",
        "On Facebook or Twitter": "From what person or organization?",
        "On another website": "What website?",
        "In the news": "From which news source?",
        "Word of mouth": "From what person or organization?",
        "Other": "Where?"
      }[this.$("select[name=referral_source] option:selected").val()];
      if (question) {
        this.$(".referral_metadata_li").show();
        this.$(".referral_metadata_li label").html(question);
      } else {
        this.$(".referral_metadata_li").hide();
      }
    }, this));
  }
});
