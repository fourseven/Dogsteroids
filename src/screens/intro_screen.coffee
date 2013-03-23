game = window.game || {}
game.IntroScreen = cc.Layer.extend(
  isMouseDown: false

  addDelayToObject: (object) ->
    this.scheduleOnce ->
      object.setVisible(true)
    , 1.0

  addBackground: (size) ->
    @backgroundSprite = cc.Sprite.create(s_Splash)
    @backgroundSprite.setPosition cc.p(size.width / 2, size.height / 2)
    @backgroundSprite.setScale 0.5
    @addChild @backgroundSprite

  addTitleSprite: (size)->
    # Title sprite
    @titleSprite = cc.Sprite.create(s_Title_TitleText)
    @titleSprite.setPosition cc.p(size.width / 2, 0)
    @titleSprite.setScale 0.5
    @addChild @titleSprite, 10
    @titleSprite.runAction cc.MoveBy.create(0.8, cc.p(0, size.height - 210))


  addAsShipSprite: (size) ->
    asShipSprite = cc.MenuItemImage.create s_Title_AsShip, s_Title_AsShip, @onNewAsShip
    asShipSprite.setScale 0.5
    asShipSprite.setVisible(false)
    @addDelayToObject(asShipSprite)
    asShipSprite


  addAsDirectorSprite: (size) ->
    asDirectorSprite = cc.MenuItemImage.create s_Title_AsDirector, s_Title_AsDirector, @onNewAsDirector
    asDirectorSprite.setAnchorPoint cc.p(0.5, 0.5)
    asDirectorSprite.setScale 0.5
    asDirectorSprite.setVisible(false)
    @addDelayToObject(asDirectorSprite)
    asDirectorSprite

  addMenuButton: (size) ->
    menu = cc.Menu.create(@addAsShipSprite(size), @addAsDirectorSprite(size))
    menu.alignItemsVerticallyWithPadding(10)
    menu.setPosition(size.width / 2, size.height / 2 - 160)
    @addChild menu, 5, 2

  init: ->
    selfPointer = this

    #////////////////////////////
    # 1. super init first
    @_super()

    # ask director the window size
    size = cc.Director.getInstance().getWinSize()

    # add splash screen background
    @addBackground(size)

    lazyLayer = new cc.LazyLayer()
    @addChild lazyLayer, 2

    # Title sprite
    @addTitleSprite(size)

    # Other sprites
    @addMenuButton(size)

    @setTouchEnabled true
    true

  onNewAsShip: (sender) ->
    console.log("new ship game")

  onNewAsDirector: (sender) ->
    console.log("new director game")
)
game.IntroScreenScene = cc.Scene.extend(onEnter: ->
  @_super()
  layer = new game.IntroScreen()
  layer.init()
  @addChild layer
)
