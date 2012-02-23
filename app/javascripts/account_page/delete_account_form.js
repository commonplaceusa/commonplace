
var DeleteAccountForm = CommonPlace.View.extend({
  template: "account_page/delete-account-form",
  id: "delete-account-form",
  
  events: { "click button.delete": "deleteAccount" },

  deleteAccount: function() {
    CommonPlace.account.destroy({ 
      success: function() {
        window.location.href = "/" + CommonPlace.community.get('slug');
      }
    });
  }

});
