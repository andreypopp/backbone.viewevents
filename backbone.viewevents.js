// Generated by CoffeeScript 1.4.0
var __slice = [].slice,
  __hasProp = {}.hasOwnProperty,
  __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

(function(root, factory) {
  if (typeof define === 'function' && define.amd) {
    return define(['backbone', 'underscore'], function(Backbone, _) {
      return root.Backbone.ViewEvents = factory(Backbone, _);
    });
  } else if (typeof require === 'function' && ((typeof module !== "undefined" && module !== null ? module.exports : void 0) != null)) {
    return module.exports = factory(require('backbone'), require('undercore'));
  } else {
    return root.Backbone.ViewEvents = factory(root.Backbone, root._);
  }
})(this, function(Backbone, _arg) {
  var View, ViewEvents, eventSplitter, extend, mangleEventName, uniqueId;
  extend = _arg.extend, uniqueId = _arg.uniqueId;
  eventSplitter = /\s+/;
  mangleEventName = function(name, context) {
    var ctxNs, names;
    ctxNs = context != null ? (!context._ctxId ? context._ctxId = uniqueId('ctxId') : void 0, '.' + context._ctxId) : '';
    name = name.trim();
    if (eventSplitter.test(name)) {
      name.split(eventSplitter);
      names = (function() {
        var _i, _len, _results;
        _results = [];
        for (_i = 0, _len = names.length; _i < _len; _i++) {
          name = names[_i];
          _results.push("viewevent:" + name + ".viewevent" + ctxNs);
        }
        return _results;
      })();
      return names.join(" ");
    } else {
      return "viewevent:" + name + ".viewevent" + ctxNs;
    }
  };
  ViewEvents = {
    on: function(name, callback, context) {
      var c, n,
        _this = this;
      if (typeof name === 'object') {
        for (n in name) {
          c = name[n];
          this.on(n, c, callback);
        }
      } else {
        this.$el.on(mangleEventName(name, context), function() {
          var args, e;
          e = arguments[0], args = 2 <= arguments.length ? __slice.call(arguments, 1) : [];
          return callback.apply(context, args);
        });
      }
      return this;
    },
    once: function(name, callback, context) {
      var c, n,
        _this = this;
      if (typeof name === 'object') {
        for (n in name) {
          c = name[n];
          this.once(n, c, callback);
        }
      } else {
        this.$el.one(mangleEventName(name, context), function() {
          var args, e;
          e = arguments[0], args = 2 <= arguments.length ? __slice.call(arguments, 1) : [];
          return callback.apply(context, args);
        });
      }
      return this;
    },
    off: function(name, callback, context) {
      var c, n;
      if (!name && !callback) {
        if ((context != null ? context._ctxId : void 0) != null) {
          this.$el.off('.' + context._ctxId);
        } else {
          this.$el.off('.viewevent');
        }
      } else if (typeof name === 'object') {
        for (n in name) {
          c = name[n];
          this.off(n, c, callback);
        }
      } else {
        this.$el.off(mangleEventName(name, context), callback);
      }
      return this;
    },
    trigger: function() {
      var args, name;
      name = arguments[0], args = 2 <= arguments.length ? __slice.call(arguments, 1) : [];
      args.push({
        view: this,
        type: name
      });
      this.$el.trigger(mangleEventName(name), args);
      return this;
    }
  };
  View = (function(_super) {

    __extends(View, _super);

    function View() {
      return View.__super__.constructor.apply(this, arguments);
    }

    return View;

  })(Backbone.View);
  extend(View.prototype, ViewEvents);
  return {
    View: View,
    ViewEvents: ViewEvents
  };
});
