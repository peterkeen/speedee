window.Thread = Backbone.Model.extend({
});

window.ThreadCollection = Backbone.Collection.extend({
  model: Thread,
  url: function() {
    return "/api/threads?q=" + this.query;
  },

  initialize: function(models, options) {
    this.query = options.query;
  }
});