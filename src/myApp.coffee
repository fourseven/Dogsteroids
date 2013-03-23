window.game = window.game || {}

###
Copyright (c) 2010-2012 cocos2d-x.org
Copyright (c) 2008-2010 Ricardo Quesada
Copyright (c) 2011      Zynga Inc.

http://www.cocos2d-x.org

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in
all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
THE SOFTWARE.
###
game.CircleSprite = cc.Sprite.extend(
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
)

game.Helloworld = cc.Layer.extend(
  isMouseDown: false
  helloImg: null
  helloLabel: null

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

  # a selector callback
  menuCloseCallback: (sender) ->
    cc.Director.getInstance().end()

  onTouchesBegan: (touches, event) ->
    @isMouseDown = true

  onTouchesMoved: (touches, event) ->
    touches  if @isMouseDown


  #this.circle.setPosition(cc.p(touches[0].getLocation().x, touches[0].getLocation().y));
  onTouchesEnded: (touches, event) ->
    @isMouseDown = false

  onTouchesCancelled: (touches, event) ->
    console.log "onTouchesCancelled"
)
game.HelloWorldScene = cc.Scene.extend(onEnter: ->
  @_super()
  layer = new game.Helloworld()
  layer.init()
  @addChild layer
)
