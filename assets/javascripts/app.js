window.Links = Ember.Application.create();

Links.Store = DS.Store.extend({
  revision: 11,
  adapter: 'DS.RESTAdapter'
});

Links.List = DS.Model.extend({
  urls: DS.hasMany('Links.Url', { embedded: true })
});

Links.Url = DS.Model.extend({
  url: DS.attr('string'),
  list: DS.belongsTo('Links.List')
});

Links.Router.map(function(match) {
  match('/').to('index');
  match('/:list_id').to('links');
});

Links.linksRoute = Ember.Route.extend({
  model: function(params) {
    return Links.List.find(params.list_id);
  }
});