window.HeaderView = Backbone.View.extend({
    render: function () {
        $(this.el).html(this.template());
        $(this.el).find('#search-form').html(new SearchView().render().el);
        return this;
    }
});

window.SearchView = Backbone.View.extend({
    render: function() {
        $(this.el).html(this.template());
        return this;
    },
    events: {
        "submit form": "search"
    },
    search: function() {
      var query = $("#searchText").val();
      this.navigate("search/" + query, {trigger: true});
      return false;
    }
});