((root, factory) ->
  if typeof define == 'function' and define.amd
    define ['backbone', 'underscore'], (Backbone, _) ->
      root.Backbone.ViewEvents = factory(Backbone, _)
  else if typeof require == 'function' and module?.exports?
    module.exports = factory(require('backbone'), require('undercore'))
  else
    root.Backbone.ViewEvents = factory(root.Backbone, root._)
) this, (Backbone, {extend}) ->

  ViewEvents =

    on: (name, callback, context) ->
      this.$el.on name, (e, args...) =>
        callback.apply(context, args)
      this

    once: (name, callback, context) ->
      this.$el.one name, (e, args...) =>
        callback.apply(context, args)
      this

    off: (name, callback, context) ->
      this.$el.off(name, callback)
      this

    trigger: (name, args...) ->
      args.push({view: this, type: name})
      this.$el.trigger(name, args...)
      this

  class View extends Backbone.View

  extend(View.prototype, ViewEvents)

  {View, ViewEvents}
