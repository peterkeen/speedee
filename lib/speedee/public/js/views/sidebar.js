window.SidebarView = Backbone.View.extend({
  initialize: function(opts) {
    this.tags = opts.tags;
    this.searches = opts.searches;
  },
  render: function() {
    $(this.el).html(this.template({tags: this.tags, searches: this.searches}));
    return this;
  }
});