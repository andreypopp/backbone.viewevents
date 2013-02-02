define (require) ->

  {View} = require 'backbone.viewevents'

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

    it 'should allow to use once', ->
      parent = new ParentView().render()
      child = new View().render()
      parent.$a.append(child.$el)

      parentNotified = 0

      parent.once 'trick', (e) ->
        parentNotified += 1

      child.trigger 'trick'
      child.trigger 'trick'

      expect(parentNotified).to.be.equal 1
