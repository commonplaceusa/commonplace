var DiscountPage = CommonPlace.View.extend({
  template: "discount_page/main",

  businesses: function() { 
    return CommonPlace.community.get('discount_businesses');
  },
  
  bind: function() { this.el.addClass("discount"); },
  unbind: function() { this.el.removeClass("discount"); }
});
