Backbone.ViewEvents
===================

DOM events for Backbone.Views

This plugin provides an alternative ``Backbone.Events`` implementation
specifically for ``Backbone.View`` which uses underlying DOM element to trigger
and listen events.

That way events from a view can bubble up through a DOM hierarchy and reach
parent views' DOM elements and so those views themselves.

Getting started
---------------

The library can be installed over ``npm`` or ``bower`` package managers::

  % npm install backbone.viewevents

and exposes itself as CommonJS and AMD module in addition to exporting a
``Backbone.ViewEvents`` global.

Usage
-----

The library exposes ``ViewEvents`` mixin for ``Backbone.View``::

  var ViewEvents = require('backbone.viewevents').ViewEvents,
      View = require('backbone').View,
      extend = require('underscore').extend;

  extend(View.prototype, ViewEvents);

  var parent = new View().render(),
      child = new View().render();

  parent.$el.append(child.$el);

  // register listener on parent
  parent.on('someevent', function (msg) {
    console.log('caught!', msg);
  });

  // trigger event on child
  child.trigger('someevent', 'hello');

This approach can be extremely performant in the cases where a lot of
subscription on child views' events are required. Furthermore, view hierarchy
is inferred automatically from views' positions in DOM.

Development
-----------

Development of the library takes place in the  GitHub
`andreypopp/backbone.viewevents`_ repository.

Before submitting any pull requests please make sure with ``make test`` that all
tests pass.

.. _`andreypopp/backbone.viewevents`: https://github.com/andreypopp/backbone.viewevents
