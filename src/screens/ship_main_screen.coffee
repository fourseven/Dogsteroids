game.ShipMainScreen = cc.Layer.extend
  init: ->
    selfPointer = @
    @_super()

game.ShipMainScreenScene = cc.Scene.extend
  _playerShip: null

  onEnter: ->
    @_super()
    layer = new game.ShipMainScreen()
    _playerShip = new PlayerShip()
    layer.init()
    @addChild layer


PlayerShip = cc.Sprite.extend
  _radians: 0
  ctor: ->
    @_super()

  draw: ->
    cc.renderContext.fillStyle = "rgba(255,255,255,1)"
    cc.renderContext.strokeStyle = "rgba(255,255,255,1)"
    @_radians = 360  if @_radians < 0
    cc.drawingUtil.drawCircle cc.PointZero(), 30, cc.DEGREES_TO_RADIANS(@_radians), 60, true

  myUpdate: (dt) ->
    @_radians -= 6
