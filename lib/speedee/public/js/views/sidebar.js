window.SidebarView = Backbone.View.extend({
  initialize: function(opts) {
    this.tags = opts.tags;
  },
  render: function() {
    $(this.el).html(this.template({tags: this.tags}));
    return this;
  }
});