window.Router = Backbone.Router.extend({

    routes: {
        "": "home"
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
      this.threadList = new ThreadCollection();
      this.threadListView = new ThreadListView({model: this.threadList});
      var self = this;
      this.threadList.fetch();
      $('#content').html(self.threadListView.render().el);
    }

});

templateLoader.load(["ThreadListItemView", "HeaderView"],
    function () {
        app = new Router();
        Backbone.history.start();
    });