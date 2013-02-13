((root, factory) ->
  if typeof define == 'function' and define.amd
    define ['backbone', 'underscore'], (Backbone, _) ->
      root.Backbone.ViewEvents = factory(Backbone, _)
  else if typeof require == 'function' and module?.exports?
    module.exports = factory(require('backbone'), require('undercore'))
  else
    root.Backbone.ViewEvents = factory(root.Backbone, root._)
) this, (Backbone, {extend}) ->

  eventSplitter = /\s+/

  mangleEventName = (name) ->
    name = name.trim()
    if eventSplitter.test name
      name.split(eventSplitter)
      names = for name in names
        "viewevent:#{name}"
      names.join(" ")
    else
      "viewevent:#{name}"

  ViewEvents =

    on: (name, callback, context) ->
      if (typeof name == 'object')
        for n, c of name
          this.on(n, c, context)
      else
        this.$el.on mangleEventName(name), (e, args...) =>
          callback.apply(context, args)
      this

    once: (name, callback, context) ->
      if (typeof name == 'object')
        for n, c of name
          this.once(n, c, context)
      else
        this.$el.one mangleEventName(name), (e, args...) =>
          callback.apply(context, args)
      this

    off: (name, callback, context) ->
      if (typeof name == 'object')
        for n, c of name
          this.off(n, c, context)
      else
        this.$el.off(mangleEventName(name), callback)
      this

    trigger: (name, args...) ->
      args.push({view: this, type: name})
      this.$el.trigger(mangleEventName(name), args...)
      this

  class View extends Backbone.View

  extend(View.prototype, ViewEvents)

  {View, ViewEvents}
