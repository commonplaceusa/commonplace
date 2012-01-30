ProfileHistoryItem = CommonPlace.View.extend({
  
  to_html: function() {
    var template = "main_page.history_items." + this.model['schema'];
    return this.renderTemplate(template, 
                               _.extend({}, 
                                        this.model, 
                                        { name: this.options.name })
                              )
  }

}); 
