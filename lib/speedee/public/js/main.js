function formatEpoch(epoch, format){
    var d = moment.unix(epoch);
    return d.format(format);
}


window.Router = Backbone.Router.extend({

    routes: {
      "": "home",
      "search/:query": "search",
      "thread/:id": "thread"
    },

    initialize: function () {
        this.headerView = new HeaderView();
        this.sidebarView = new SidebarView({tags: [], searches: []});

        var self = this;

        $.getJSON('/api/tags', {}, function(result) {
          self.sidebarView.tags = result;
          $('#sidebar').html(self.sidebarView.render().el);
        });
        $.getJSON('/api/searches', {}, function(result) {
          self.sidebarView.searches = result;
          $('#sidebar').html(self.sidebarView.render().el);
        });
        $('.header').html(this.headerView.render().el);
        $('#sidebar').html(this.sidebarView.render().el);

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
      $('#searchForm').find('input:text').val('');
    },

    search: function(query) {
      this.threadList = new ThreadCollection([], {query: query});
      this.threadListView = new ThreadListView({model: this.threadList});
      var self = this;
      this.threadList.fetch();
      $('#content').html(self.threadListView.render().el);
    },

    thread: function(id) {
      this.messages = new MessageCollection([], {threadId: id});
      this.threadView = new ThreadView({model: this.messages});
      var self = this;
      this.messages.fetch();
      this.messages.thread.fetch();
      $('#content').html(self.threadView.render().el);
    }
});

templateLoader.load(["ThreadListItemView", "HeaderView", "ThreadListView", "SidebarView", "SearchView", "ThreadView", "ThreadItemView"],
    function () {
      app = new Router();

      Backbone.View.prototype.navigate = function(url, options) {
        app.navigate(url, options);
      };

      Backbone.history.start();
    });