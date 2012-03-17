var YahooContacts = {

  prepare: function(callback) {
    window.YahooContactsCallback = callback;
  },

  retrievePairedContacts: function(oauth_verifier) {
    $.ajax({
      type: "GET",
      contentType: "application/json",
      url: "/api/contacts/get/" + oauth_verifier,
      success: function(response) {
        var contacts = [];
        _.each(response, function(raw_contact) {
          if (raw_contact.name && raw_contact.emails.length > 0) {
            var contact = {
              full_name: raw_contact.name,
              name: raw_contact.name,
              email: raw_contact.emails[0],
              avatar_url: undefined,
              first_name: _.first(raw_contact.name.split(" ")),
              last_name: _.last(raw_contact.name.split(" "))
            };
            contacts.push(contact);
          }
        });
        window.YahooContactsCallback.success(contacts);
      }
    });
  },

  handleError: function(err) {
  }
};
