window.ThreadListHeaderView = Backbone.View.extend({
  render: function() {
    $(this.el).html(this.template());
    return this;
  }
});

window.ThreadListView = Backbone.View.extend({
  initialize: function() {
    this.model.bind("reset", this.render, this);
  },

  render: function() {
    $(this.el).html(this.template());
    _.each(this.model.models, function(thread) {
      $(this.el).find('tbody').append(new ThreadListItemView({model: thread}).render().el);
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