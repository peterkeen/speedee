window.Router = Backbone.Router.extend({

    routes: {
      "": "home",
      "search/:query": "search"
    },

    initialize: function () {
        this.headerView = new HeaderView();
        $('.header').html(this.headerView.render().el);

        // Close the search dropdown on click anywhere in the UI
        $('body').click(function () {
            $('.dropdown').removeClass("open");
        });
    },

    home: function () {
      this.threadList = new ThreadCollection([], {query: "tag:inbox"});
      this.threadListView = new ThreadListView({model: this.threadList});
      var self = this;
      this.threadList.fetch();
      $('#content').html(self.threadListView.render().el);
    },

    search: function(query) {
      this.threadList = new ThreadCollection([], {query: query});
      this.threadListView = new ThreadListView({model: this.threadList});
      var self = this;
      this.threadList.fetch();
      $('#content').html(self.threadListView.render().el);
    }

});

templateLoader.load(["ThreadListItemView", "HeaderView", "ThreadListView", "SearchView"],
    function () {
      app = new Router();

      Backbone.View.prototype.navigate = function(url, options) {
        app.navigate(url, options);
      };

      Backbone.history.start();
    });