game.ShipMainScreen = cc.LayerColor.extend
  _shipSprite: null
  _bulletArray: []
  ctor: ->
    @_super new cc.Color4B(0, 0, 0, 255)
    @_shipSprite = new PlayerShip(this)
    @setTouchEnabled true
    @setKeyboardEnabled true
    @setPosition new cc.Point(0, 0)
    @addChild @_shipSprite
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

  fireBullet: (position, currentRotation) ->
    bullet = new PlayerShipBullet(@_shipSprite.getPosition(), @_shipSprite.getCurrentRotation())
    @addChild bullet
    bullet.runAction bullet.actionMove(), () ->
      cc.CallFunc.create((node) ->
        cc.ArrayRemoveObject(@_bulletArray, node)
        node.removeFromParent()
      , this)

game.ShipMainScreenScene = cc.Scene.extend
  onEnter: ->
    @_super()
    @addChild new game.ShipMainScreen()


PlayerShip = cc.Sprite.extend
  ROTATION_VECTOR: 15
  _currentVelocity: 0
  _currentRotation: 90
  _position: null
  _size: null
  _scene: null
  ctor: (scene)->
    @_super()
    @_scene = scene
    @initWithFile(s_Ship_Stationary)
    @_size = cc.Director.getInstance().getWinSize()
    @_position = new cc.Point(@_size.width / 2, @_size.height / 2)
    @setPosition @_position

  update: (dt) ->
    @setRotation(this._currentRotation - 90)
    @moveShip()

  getPosition: () ->
    @_position

  getCurrentRotation: () ->
    @_currentRotation

  handleKey: (e) ->
    if (e == cc.KEY.left)
      @_currentRotation = @_currentRotation - @ROTATION_VECTOR
    if (e == cc.KEY.right)
      @_currentRotation = @_currentRotation + @ROTATION_VECTOR
    if (e == cc.KEY.up)
      @_currentVelocity += 1
    if (e == cc.KEY.down)
      @_currentVelocity -= 1
    if (e == cc.KEY.space)
      console.log("Space was pressed")
      @_scene.fireBullet()


    @_currentVelocity =  10 if (@_currentVelocity >  10)
    @_currentVelocity = -10 if (@_currentVelocity < -10)

    @_currentRotation = 360 if(@_currentRotation < 0)
    @_currentRotation = 0   if(@_currentRotation > 360)

  handleTouchMove: (touchLocation) ->
    # Gross use of hardcoded width,height params.
    angle = Math.atan2(touchLocation.x-300,touchLocation.y-300)

    angle = angle * (180/Math.PI)
    this._currentRotation = angle

  moveShip: () ->
    xChange = @_currentVelocity * Math.cos(@_currentRotation * Math.PI / 180)
    yChange = @_currentVelocity * Math.sin(@_currentRotation * Math.PI / 180)
    @_position.x -= xChange
    @_position.y += yChange
    @sanitizeX()
    @sanitizeY()

    return

  sanitizeX: () ->
    maxX = @_size.width + @getBoundingBox().width/2
    # RIGHT
    if @_position.x > maxX
      @_position.x = @_position.x % maxX
    # LEFT
    if @_position.x < -@getBoundingBox().width/2
      @_position.x = maxX

  sanitizeY: () ->
    maxY = @_size.height + @getBoundingBox().height/2
    # BOTTOM
    if @_position.y > maxY
      @_position.y = @_position.y % maxY
    # TOP
    if @_position.y < -@getBoundingBox().height/2
      @_position.y = maxY

PlayerShipBullet = cc.Sprite.extend
  BULLET_VELOCITY: 12
  _angle: null
  _position: null
  LONGEST_LENGTH: 0
  ctor: (sourcePosition, angle)->
    @_super()
    @initWithFile(s_Ship_Bullet)
    @_size = cc.Director.getInstance().getWinSize()
    @_position = new cc.Point(sourcePosition.x, sourcePosition.y)
    @LONGEST_LENGTH = Math.sqrt( (@_size.width * @_size.width) + (@_size.height * @_size.height))
    @_angle = angle - 90
    @setPosition @_position
    @createMovement

  actionMove: () ->
    duration = @calculateDuration()
    cc.MoveTo.create(duration, @cacluateEndPosition())

  calculateDuration: () ->
    duration = @LONGEST_LENGTH / 60 / @BULLET_VELOCITY
    duration

  cacluateEndPosition: () ->
    finalX = @LONGEST_LENGTH * Math.sin(@_angle * Math.PI / 180) + @_position.x
    finalY = @LONGEST_LENGTH * Math.cos(@_angle * Math.PI / 180) + @_position.y
    new cc.Point(finalX, finalY)

