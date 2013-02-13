define (require) ->

  {View} = require 'backbone.viewevents'
  {extend} = require 'underscore'
  Backbone = require 'backbone'

  class ParentView extends View

    render: ->
      this.$el.html """
        <div class="a"></div>
      """
      this.$a = this.$('.a')
      this

  describe 'View with ViewEvents', ->

    it 'should bubble up events through view hierarchy', ->
      parent = new ParentView().render()
      child = new View().render()
      parent.$a.append(child.$el)

      parentNotified = false

      parent.on 'trick', (e) ->
        parentNotified = e

      child.trigger 'trick'

      expect(parentNotified).to.be.ok
      expect(parentNotified.type).to.be.equal 'trick'
      expect(parentNotified.view.cid).to.be.equal child.cid

    it 'should allow to use .once()', ->
      parent = new ParentView().render()
      child = new View().render()
      parent.$a.append(child.$el)

      parentNotified = 0

      parent.once 'trick', (e) ->
        parentNotified += 1

      child.trigger 'trick'
      child.trigger 'trick'

      expect(parentNotified).to.be.equal 1

    it 'should allow to use .off()', ->
      parent = new ParentView().render()
      child = new View().render()
      parent.$a.append(child.$el)

      parentNotified = 0

      parent.on 'trick', (e) ->
        parentNotified += 1

      child.trigger 'trick'
      parent.off 'trick'
      child.trigger 'trick'

      expect(parentNotified).to.be.equal 1

    it 'should not interfere with DOM events', ->
      parent = new ParentView().render()
      child = new View().render()
      parent.$a.append(child.$el)

      parentNotified = 0

      parent.on 'click', (e) ->
        parentNotified += 1

      child.$el.click()

      expect(parentNotified).to.be.equal 0

    it 'should allow to use .on() by passing an object of event, callback pairs', ->
      parent = new ParentView().render()
      child = new View().render()
      parent.$a.append(child.$el)

      parentTricked = false
      parentNotified = false

      parent.on
        notify: (e) -> parentNotified = e
        trick: (e) -> parentTricked = e

      expect(parentNotified).not.to.be.ok

      child.trigger 'notify'

      expect(parentNotified).to.be.ok
      expect(parentNotified.type).to.be.equal 'notify'
      expect(parentNotified.view.cid).to.be.equal child.cid

      expect(parentTricked).not.to.be.ok

      child.trigger 'trick'

      expect(parentTricked).to.be.ok
      expect(parentTricked.type).to.be.equal 'trick'
      expect(parentTricked.view.cid).to.be.equal child.cid

    it 'should allow to use .listenTo()', ->
      listener = extend {}, Backbone.Events
      view = new View()

      tricked = false

      listener.listenTo view, 'trick', (e) ->
        tricked = e

      view.trigger 'trick'

      expect(tricked).to.be.ok
      expect(tricked.type).to.be.equal 'trick'
      expect(tricked.view.cid).to.be.equal view.cid

    it 'should allow to use .stopListening()', ->
      listener = extend {}, Backbone.Events
      view = new View()

      tricked = 0

      listener.listenTo view, 'trick', (e) ->
        tricked += 1

      view.trigger 'trick'

      listener.stopListening()

      view.trigger 'trick'

      expect(tricked).to.be.equal 1

    it 'should allow to use .stopListening(obj)', ->
      listener = extend {}, Backbone.Events
      view = new View()

      tricked = 0

      listener.listenTo view, 'trick', (e) ->
        tricked += 1

      view.trigger 'trick'

      listener.stopListening(view)

      view.trigger 'trick'

      expect(tricked).to.be.equal 1
