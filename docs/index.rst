Backbone.ViewEvents
===================

DOM events for Backbone.Views

This plugin provides an alternative ``Backbone.Events`` implementation
specifically for ``Backbone.View`` which uses underlying DOM element to trigger
and listen to events.

The way it works events from a view can bubble up through a DOM hierarchy and
reach parent views' DOM elements and so those views themselves.

Rationale
---------

Sometimes it is required to listen to events from a lot of child views. This can
be done by looping over all child views and calling ``.listenTo()`` method but
it `(a)` requires you to have references to all those child view and `(b)` isn't
that performant especially if you have a lot of views to listen to.

By triggering and listening to events on DOM element instead of using
``Backbone.Events`` we can get events bubble up through the DOM hierarchy and so
reach the parent view. Also reusing DOM events is more performant than mimicing
them via synthetical implementation.

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

As you can see ``parent`` view didn't subscribe to ``child`` and still gets the
``someevent`` event.

Development
-----------

Development of the library takes place in the  GitHub
`andreypopp/backbone.viewevents`_ repository.

Before submitting any pull requests please make sure with ``make test`` that all
tests pass.

.. _`andreypopp/backbone.viewevents`: https://github.com/andreypopp/backbone.viewevents
