var DiscountPage = CommonPlace.View.extend({
  template: "discount_page/main",

  businesses: function() { 
    return CommonPlace.community.get('discount_businesses');
  },
  
  bind: function() { $("body").addClass("discount"); },
  unbind: function() { $("body").removeClass("discount"); }
});
