window.Thread = Backbone.Model.extend({
});

window.ThreadCollection = Backbone.Collection.extend({
  model: Thread,
                                                  url: "/api/threads",
                                                  parse: function(response) {
                                                    console.log(response);
                                                    return response;
                                                  }
});