((root, factory) ->
  if typeof define == 'function' and define.amd
    define ['backbone', 'underscore'], (Backbone, _) ->
      root.Backbone.ViewEvents = factory(Backbone, _)
  else if typeof require == 'function' and module?.exports?
    module.exports = factory(require('backbone'), require('undercore'))
  else
    root.Backbone.ViewEvents = factory(root.Backbone, root._)
) this, (Backbone, {extend, uniqueId}) ->

  eventSplitter = /\s+/

  mangleEventName = (name, context) ->
    ctxNs = if context?
      context._ctxId = uniqueId('ctxId') if not context._ctxId
      '.' + context._ctxId
    else
      ''
    name = name.trim()
    if eventSplitter.test name
      name.split(eventSplitter)
      names = for name in names
        "viewevent:#{name}.viewevent#{ctxNs}"
      names.join(" ")
    else
      "viewevent:#{name}.viewevent#{ctxNs}"

  ViewEvents =

    on: (name, callback, context) ->
      if (typeof name == 'object')
        for n, c of name
          this.on(n, c, callback)
      else
        this.$el.on mangleEventName(name, context), (e, args...) =>
          callback.apply(context, args)
      this

    once: (name, callback, context) ->
      if (typeof name == 'object')
        for n, c of name
          this.once(n, c, callback)
      else
        this.$el.one mangleEventName(name, context), (e, args...) =>
          callback.apply(context, args)
      this

    off: (name, callback, context) ->
      if not name and not callback
        if context?._ctxId?
          this.$el.off('.' + context._ctxId)
        else
          this.$el.off('.viewevent')
      else if (typeof name == 'object')
        for n, c of name
          this.off(n, c, callback)
      else
        this.$el.off(mangleEventName(name, context), callback)
      this

    trigger: (name, args...) ->
      args.push({view: this, type: name})
      this.$el.trigger(mangleEventName(name), args...)
      this

  class View extends Backbone.View

  extend(View.prototype, ViewEvents)

  {View, ViewEvents}
