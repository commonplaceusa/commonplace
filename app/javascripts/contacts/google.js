var GoogleContacts = {
  contactsFeedUrl: "https://www.google.com/m8/feeds/contacts/default/full",
  maximumResultCount: 500,
  contactsAvailable: false,
  contactsService: undefined,
  contactsScope: "https://www.google.com/m8/feeds",
  callback: {},

  prepare: function(callback) {
    this.contactsService = new google.gdata.contacts.ContactsService('test-123');
    window.googleContactsService = this.contactsService;
    window.GoogleContactsCallback = callback;
    if (google.accounts.user.checkLogin(this.contactsScope))
      this.getContacts();
  },

  retrievePairedContacts: function(callback) {
    this.logMeIn();
    this.getContacts();
  },

  logMeIn: function() {
    google.accounts.user.login(this.contactsScope);
  },

  getContacts: function() {
    this.callback = {};
    var query = new google.gdata.contacts.ContactQuery(this.contactsFeedUrl);
    query.setMaxResults(this.maximumResultCount);
    window.googleContactsService.getContactFeed(query, this.handleContactsFeed, this.handleError);
  },

  handleContactsFeed: function(result) {
    var entries = result.feed.entry;
    var contacts = [];
    for (var i = 0; i < entries.length; i++) {
      var contactEntry = entries[i];
      var contactName = contactEntry.getTitle().getText();
      var emailAddresses = contactEntry.getEmailAddresses();
      var emailAddress;
      for (var j = 0; j < emailAddresses.length; j++) {
        emailAddress = emailAddresses[j].getAddress();
      }
      var contact = {
        full_name: contactName,
        name: contactName,
        email: emailAddress,
        avatar_url: undefined,
        first_name: _.first(contactName.split(" ")),
        last_name: _.last(contactName.split(" "))
      };
      contacts.push(contact);
    }
    window.GoogleContactsCallback.success(contacts);
    window.GoogleContactsCallback = undefined;
  },

  handleError: function(err) {
  }
};
