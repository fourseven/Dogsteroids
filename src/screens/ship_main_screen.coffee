# game.ShipMainScreen = cc.Layer.extend
#   ctor: ->
#     size = cc.Director.getInstance().getWinSize()
#     selfPointer = @
#     @_super()

#     layer1 = cc.LayerColor.create(new cc.Color4B(0, 0, 0, 255), size.width, size.height)
#     shipSprite = cc.Sprite.create(s_Ship_Stationary)
#     layer1.setPosition new cc.Point(0.0, 0.0)
#     layer1.addChild shipSprite
#     shipSprite.setPosition new cc.Point(size.width / 2, size.height / 2)
#     @addChild layer1
#     true

game.ShipMainScreen = cc.LayerColor.extend
  _shipSprite: null
  ctor: ->
    @_super new cc.Color4B(0, 0, 0, 255)
    size = cc.Director.getInstance().getWinSize()
    @_shipSprite = new PlayerShip()
    @setTouchEnabled true
    @setKeyboardEnabled true
    @setPosition new cc.Point(0, 0)
    @addChild @_shipSprite
    @_shipSprite.setPosition new cc.Point(size.width / 2, size.height / 2)
    @_shipSprite.scheduleUpdate()
    @schedule @update
    true

  onEnter: ->
    @_super()

  update: (dt) ->

  onTouchesEnded: (pTouch, pEvent) ->


  onTouchesMoved: (pTouch, pEvent) ->
    @_shipSprite.handleTouchMove pTouch[0].getLocation()

  onKeyUp: (e) ->

  onKeyDown: (e) ->
    @_shipSprite.handleKey e

game.ShipMainScreenScene = cc.Scene.extend
  onEnter: ->
    @_super()
    @addChild new game.ShipMainScreen()


PlayerShip = cc.Sprite.extend
  ROTATION_VECTOR: 10
  _currentRotation: 0
  ctor: ->
    @_super()
    @initWithFile(s_Ship_Stationary)

  update: (dt) ->
    this.setRotation(this._currentRotation)

  handleKey: (e) ->
    if (e == cc.KEY.left)
      @_currentRotation = @_currentRotation - @ROTATION_VECTOR
    else if (e == cc.KEY.right)
      @_currentRotation = @_currentRotation + @ROTATION_VECTOR

    @_currentRotation = 360 if(@_currentRotation < 0)
    @_currentRotation = 0   if(@_currentRotation > 360)

  handleTouchMove: (touchLocation) ->
    # Gross use of hardcoded width,height params.
    angle = Math.atan2(touchLocation.x-300,touchLocation.y-300)

    angle = angle * (180/Math.PI)
    this._currentRotation = angle

  myUpdate: (dt) ->
    @_radians -= 6
