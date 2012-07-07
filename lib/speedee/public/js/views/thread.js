window.ThreadView = Backbone.View.extend({
  initialize: function() {
    this.model.bind("reset", this.render, this);
    this.model.thread.bind("reset", this.render, this);
  },
  render: function() {
    if (this.model.thread.has("subject")) {
      $(this.el).html(this.template(this.model.thread.toJSON()));
    } else {
      $(this.el).html(this.template({subject: ''}));
    }

    _.each(this.model.models, function(message) {
      $(this.el).find('.messages').append(new ThreadItemView({model: message}).render().el);
    }, this);
    return this;
  }
});

window.ThreadItemView = Backbone.View.extend({
  className: 'row-fluid',
  render: function(eventName) {
    $(this.el).html(this.template(this.model.toJSON()));
    return this;
  }
});