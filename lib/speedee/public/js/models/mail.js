window.Message = Backbone.Model.extend();

window.MessageCollection = Backbone.Collection.extend({
  model: Message,
  url: function() {
    return '/api/threads/' + this.threadId + '/messages';
  },
  initialize: function(models, opts) {
    this.threadId = opts.threadId;
    this.thread = new Thread({id: opts.threadId});
  }
});


window.Thread = Backbone.Model.extend({
  url: function() {
    return "/api/threads/" + this.id;
  }
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