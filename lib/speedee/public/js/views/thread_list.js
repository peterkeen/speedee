window.ThreadListView = Backbone.View.extend({
  tagName: 'table',

  className: 'table table-striped table-bordered',

  initialize: function() {
    this.model.bind("reset", this.render, this);
  },

  render: function() {
    _.each(this.model.models, function(thread) {
      $(this.el).append(new ThreadListItemView({model: thread}).render().el);
    }, this);
    return this;
  }
});

window.ThreadListItemView = Backbone.View.extend({
  tagName: 'tr',
  render: function(eventName) {
    $(this.el).html(this.template(this.model.toJSON()));
    return this;
  }
});