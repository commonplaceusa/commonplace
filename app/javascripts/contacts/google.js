var GoogleContacts = {
  contactsFeedUrl: "https://www.google.com/m8/feeds/contacts/default/full",
  maximumResultCount: 1,
  contactsAvailable: false,
  contactsService: undefined,
  contactsScope: "https://www.google.com/m8/feeds",
  callback: {},

  prepare: function() {
    googleLoaded = function() {
      console.log("Loaded");
      window.GoogleContactsApiPrepared = true;
      this.contactsService = new google.gdata.contacts.ContactsService('test-123');
      window.googleContactsService = this.contactsService;
    };
    googleLoaded();
  },

  retrievePairedContacts: function(callback) {
    console.log("Getting contacts");
    this.logMeIn();
    this.callback = callback;
    this.getContacts();
  },

  logMeIn: function() {
    console.log("logmein");
    google.accounts.user.login(this.contactsScope);
  },

  getContacts: function() {
    console.log("getting conts");
    this.callback = {};
    var query = new google.gdata.contacts.ContactQuery(this.contactsFeedUrl);
    query.setMaxResults(this.maximumResultCount);
    console.log(query);
    window.contactsService.getContactFeed(query, this.handleContactsFeed, this.handleError);
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
        email: emailAddress,
        avatar_url: undefined,
        first_name: _.first(contactName.split(" ")),
        last_name: _.last(contactName.split(" "))
      };
      contacts.push(contact);
    }
    this.callback(contacts);
  },

  handleError: function(err) {
    console.log(err);
  }
};
