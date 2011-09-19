var WireView = CommonPlace.View.extend({
  className: "wire",
  template: "shared/wire",

  events: {
    "click a.more": "showMore"
  },

  initialize: function(options) { 
    this.account = options.account;
  },

  aroundRender: function(render) {
    var self = this;
    this.fetchCurrentPage(function() {
      render();
    });
  },

  afterRender: function() { this.appendCurrentPage(); },

  modelToView: function() { 
    throw new Error("This is an abstract class, use a child of this class");
  },

  fetchCurrentPage: function(callback) {
    this.collection.fetch({
      data: { limit: this.perPage(), page: this.currentPage() },
      success: callback
    });
  },

  appendCurrentPage: function() {
    var self = this;
    var $ul = this.$("ul.wire-list");
    this.collection.each(function(model) {
      $ul.append(self.modelToView(model).render().el);
    });
  },

  areMore: function() {
    return !(this.collection.length < this.perPage());
  },

  isEmpty: function() {
    return this.collection.isEmpty();
  },

  emptyMessage: function() {
    throw new Error("This is an abstract class, use a child of this class");
  },
    
  showMore: function(e) {
    var self = this;
    e.preventDefault();
    this.nextPage();
    this.fetchCurrentPage(function() { self.appendCurrentPage(); });
  },

  currentPage: function() {
    return (this._currentPage || this.options.currentPage || 0);
  },

  perPage: function() {
    return (this.options.perPage || 10);
  },

  nextPage: function() {
    this._currentPage = (this._currentPage || this.options.currentPage || 0) + 1;
  }
});


var PostWireView = WireView.extend({
  initialize: function(options) {
    this.account = options.account;
  },

  modelToView: function(model) {
    return new PostWireItem({
      model: model,
      account: this.account
    });
  },

  emptyMessage: "No posts here yet"
});

var EventWireView = WireView.extend({
  initialize: function(options) {
    this.account = options.account;
  },

  modelToView: function(model) {
    return new EventWireItem({
      model: model,
      account: this.account
    });
  },

  emptyMessage: "No events here yet"
});

var AnnouncementWireView = WireView.extend({
  initialize: function(options) {
    this.account = options.account;
  },

  modelToView: function(model) {
    return new AnnouncementWireItem({
      model: model,
      account: this.account
    });
  },

  emptyMessage: "No announcements here yet"
});

var UserWireView = WireView.extend({
  modelToView: function(model) {
    return new UserWireItem({model: model, account: this.account});
  },

  emptyMessage: "Nobody here yet"
});

var FeedWireView = WireView.extend({
  modelToView: function(model) {
    return new FeedWireItem({model: model, account: this.options.account});
  },

  emptyMessage: "No feeds here yet"
});

var GroupWireView = WireView.extend({
  modelToView: function(model) {
    return new GroupWireItem({model: model, account: this.options.account});
  },

  emptyMessage: "No groups here yet"
});




var GroupPostWireView = WireView.extend({
  modelToView: function(model) {
    return new GroupPostWireItem({model: model, account: this.options.account});
  },

  emptyMessage: "No posts here yet"
});


var FormView = CommonPlace.View.extend({
  initialize: function(options) {
    this.template = (this.options.template || this.template);
    this.modal = new ModalView({form: this.el});
  },

  afterRender: function() {
    this.modal.render();
  },

  events: {
    "click form a.cancel": "exit",
    "submit form": "send"
  },

  send: function(e) {
    e.preventDefault();
    this.save();
    this.exit();
  },

  exit: function(e) {
    e && e.preventDefault();
    this.modal.exit();
  }
});

var MessageFormView = FormView.extend({
  template: "shared/message-form",

  save: function() {
    this.model.save({
      subject: this.$("[name=subject]").val(),
      body: this.$("[name=body]").val()
    });
  },

  name: function() {
    return this.model.name();
  }
});

var AnnouncementFormView = FormView.extend({
  save: function() {
    this.model.save({
      title: this.$("[name=title]").val(),
      body: this.$("[name=body]").val()
    });
  },

  title: function() {
    return this.model.get("title");
  },

  body: function() {
    return this.model.get("body");
  }
});

var EventFormView = FormView.extend({
  afterRender: function() {
    this.modal.render();
    $("input.date", this.el).datepicker({dateFormat: 'yy-mm-dd'});
  },

  save: function() {
    this.model.save({
      title: this.$("[name=title]").val(),
      body: this.$("[name=body]").val(),
      occurs_at: this.$("[name=date]").val(),
      starts_at: this.$("[name=start]").val(),
      ends_at: this.$("[name=end]").val(),
      venue: this.$("[name=venue]").val(),
      address: this.$("[name=address]").val()
    });
  },

  title: function() {
    return this.model.get("title");
  },

  body: function() {
    return this.model.get("body");
  },

  date: function() {
    return this.model.get("occurs_at").split("T")[0];
  },

  venue: function() {
    return this.model.get("venue");
  },

  address: function() {
    return this.model.get("address");
  },

  time_values: function() {
    var start_value = this.model.get("starts_at").replace(" ", "");
    var end_value = this.model.get("ends_at").replace(" ", "");
    var list = _.flatten(_.map(["AM", "PM"],
      function(half) {
        return  _.map(_.range(1,13),
        function(hour) {
          return _.map(["00", "30"],
          function(minute) {
            return String(hour) + ":" + minute + " " + half;
          });
        });
      })
    );
    var result = [];
    _.each(list, function(time) {
      var obj = {
        ".": time,
        "is_start": (time.replace(" ","").toLowerCase() == start_value),
        "is_end": (time.replace(" ","").toLowerCase() == end_value)
      };
      result.push(obj);
    });
    return result;
  }
});

var ModalView = CommonPlace.View.extend({
  template: "shared/modal",
  className: "modal",

  initialize: function(options) {
    var self = this;
    this.form = this.options.form;
  },

  afterRender: function() {
    $("body").append(this.el);
    $(".modal-container").append(this.form);
    this.$("textarea").autoResize();
    this.centerEl();
  },

  centerEl: function() {
    var $el = $(".modal-container");
    var $window = $(window);
    $el.css({
      top: (($window.height() - $el.height()) /2) + $window.scrollTop(),
      left: ($window.width() - $el.width()) /2
    });

    
  },

  events: {
    "click #modal-shadow": "exit"
  },

  exit: function() {
    $(this.el).remove();
  }
});

var RepliesView = CommonPlace.View.extend({
  className: "replies",
  template: "shared/replies",
  initialize: function(options) {
    var self = this;
    this.account = options.account;
    this.collection.bind("add", function() { self.render(); });
  },
  
  afterRender: function() {
    this.$("textarea").placeholder();
    this.$("textarea").autoResize();
    this.appendReplies();
  }, 
  
  events: {
    "submit form": "sendReply"
  },

  appendReplies: function() {
    var self = this;
    var $ul = this.$("ul.reply-list");
    this.collection.each(function(reply) {
      var replyview = new ReplyWireItem({ model: reply, account: self.account });
      $ul.append(replyview.render().el);
    });
  },

  sendReply: function(e) {
    e.preventDefault();
    this.collection.create({ body: this.$("[name=body]").val()});
  },
  
  accountAvatarUrl: function() { return this.account.get('avatar_url'); }
});

