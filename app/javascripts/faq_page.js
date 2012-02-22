
var FaqPage = CommonPlace.View.extend({
  template: "faq_page/main",
  track: true,
  page_name: "faq",

  events: {
    "submit form.ask-question": "sendQuestion"
  },

  bind: function() {
    $(window)
      .bind("resize.delegateEvents" + this.cid,
            this.setSidebarPosition)
      .bind("scroll.delegateEvents" + this.cid,
            this.setSidebarPosition);
    $("body").addClass("faq");
  },

  unbind: function() {
    $(window).unbind(".delegateEvents" + this.cid);
    $("body").removeClass("faq");
  },

  setSidebarPosition: function() {
    var rightOffset = $("#content").offset().left - $("#sections_picker").width() - 30;
    if ($(this).scrollTop() + 40 <= $("#main").offset().top) {
      $("#sections_picker").css({position: "absolute", right: ""});
    }
    else{
      $("#sections_picker").css({position: "fixed", right: rightOffset});
    }
  },

  sendQuestion: function(e) {
    e.preventDefault();
    var $form = this.$("form.ask-question");
    $.ajax({
      type: "POST",
      dataType: "json",
      url: "/api" + CommonPlace.community.link("questions"),
      data: JSON.stringify({
        email: $("[name=email]", $form).val(),
        message: $("[name=message]", $form).val(),
        name: $("[name=name]", $form).val()
      }),
      success: function() {
        $("[name=message]", $form).val("");
        $("p.confirm", $form).show().delay(3000).fadeOut();
      }
    });
  }

});
