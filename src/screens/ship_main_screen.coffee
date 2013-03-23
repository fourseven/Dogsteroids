game.ShipMainScreen = cc.Layer.extend
  init: ->
    selfPointer = @
    @_super()

game.ShipMainScreenScene = cc.Scene.extend
  onEnter: ->
    @_super()
    layer = new game.ShipMainScreen()
    layer.init()
    @addChild layer
