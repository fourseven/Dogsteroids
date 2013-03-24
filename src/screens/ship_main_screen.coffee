game.ShipMainScreen = cc.LayerColor.extend
  _shipSprite: null
  ctor: ->
    @_super new cc.Color4B(0, 0, 0, 255)
    @_shipSprite = new PlayerShip()
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

game.ShipMainScreenScene = cc.Scene.extend
  onEnter: ->
    @_super()
    @addChild new game.ShipMainScreen()


PlayerShip = cc.Sprite.extend
  ROTATION_VECTOR: 15
  MOVEMENT_VECTOR: 0

  _currentRotation: 90
  _position: null
  _size: null
  ctor: ->
    @_super()
    @initWithFile(s_Ship_Stationary)
    @_size = cc.Director.getInstance().getWinSize()
    @_position = new cc.Point(@_size.width / 2, @_size.height / 2)
    @setPosition @_position

  update: (dt) ->
    @setRotation(this._currentRotation - 90)
    @moveShip()

  handleKey: (e) ->
    if (e == cc.KEY.left)
      @_currentRotation = @_currentRotation - @ROTATION_VECTOR
    if (e == cc.KEY.right)
      @_currentRotation = @_currentRotation + @ROTATION_VECTOR
    if (e == cc.KEY.up)
      @MOVEMENT_VECTOR += 1
    if (e == cc.KEY.down)
      @MOVEMENT_VECTOR -= 1


    @MOVEMENT_VECTOR =  10 if (@MOVEMENT_VECTOR >  10)
    @MOVEMENT_VECTOR = -10 if (@MOVEMENT_VECTOR < -10)

    @_currentRotation = 360 if(@_currentRotation < 0)
    @_currentRotation = 0   if(@_currentRotation > 360)

  handleTouchMove: (touchLocation) ->
    # Gross use of hardcoded width,height params.
    angle = Math.atan2(touchLocation.x-300,touchLocation.y-300)

    angle = angle * (180/Math.PI)
    this._currentRotation = angle

  moveShip: () ->
    xChange = @MOVEMENT_VECTOR * Math.cos(@_currentRotation * Math.PI / 180)
    yChange = @MOVEMENT_VECTOR * Math.sin(@_currentRotation * Math.PI / 180)
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
