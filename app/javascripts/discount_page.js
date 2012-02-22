var DiscountPage = CommonPlace.View.extend({
  template: "discount_page/main",
  track: true,
  page_name: "discount",

  businesses: function() {
    return CommonPlace.community.get('discount_businesses');
  },

  bind: function() { $("body").addClass("discount"); },
  unbind: function() { $("body").removeClass("discount"); }
});
