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

#this._addDirtyRegionToDirector(this.getBoundingBoxToWorld());
game.Helloworld = cc.Layer.extend(
  isMouseDown: false
  helloImg: null
  helloLabel: null
  circle: null
  sprite: null

  addDelayToObject: (object) ->
    this.scheduleOnce ->
      object.setVisible(true)
    , 1.0


  addTitleSprite: (size)->
    # Title sprite
    @titleSprite = cc.Sprite.create("res/Title/TitleText.png")
    @titleSprite.setPosition cc.p(size.width / 2, 0)
    @titleSprite.setScale 0.5
    @addChild @titleSprite, 10
    @titleSprite.runAction cc.MoveBy.create(0.8, cc.p(0, size.height - 210))


  addAsShipSprite: (size, lazyLayer = @) ->
    @asShipSprite = cc.MenuItemImage.create("res/Title/AsShip.png", "res/Title/AsShip.png", ->
      console.log("new game")
    , this)
    @asShipSprite.setPosition cc.p(size.width / 4, size.height - 440)
    @asShipSprite.setScale 0.5
    @asShipSprite.setVisible(false)
    lazyLayer.addChild @asShipSprite
    @asShipSprite


  addAsDirectorSprite: (size, lazyLayer = @) ->
    @asDirectorSprite = cc.MenuItemImage.create("res/Title/AsDirector.png", "res/Title/AsDirector.png", ->
      console.log("new game")
    , this)
    @asDirectorSprite.setPosition cc.p((size.width / 4) * 3, size.height - 440)
    @asDirectorSprite.setScale 0.5
    @asDirectorSprite.setVisible(false)
    lazyLayer.addChild @asDirectorSprite
    @asDirectorSprite

  addMenuButton: (size) ->
    # add a "close" icon to exit the progress. it's an autorelease object
    closeItem = cc.MenuItemImage.create("res/CloseNormal.png", "res/CloseSelected.png", ->
      history.go -1
    , this)
    closeItem.setAnchorPoint cc.p(0.5, 0.5)
    menu = cc.Menu.create(closeItem)
    menu.setPosition cc.PointZero()
    @addChild menu, 1
    closeItem.setPosition cc.p(size.width - 20, 20)

  init: ->
    selfPointer = this

    #////////////////////////////
    # 1. super init first
    @_super()

    #///////////////////////////
    # 2. add a menu item with "X" image, which is clicked to quit the program
    #    you may modify it.
    # ask director the window size
    size = cc.Director.getInstance().getWinSize()

    # add "HelloWorld" splash screen"
    backgroundLayer = new cc.LazyLayer()
    @addChild backgroundLayer
    @backgroundSprite = cc.Sprite.create("res/Splash.jpg")
    @backgroundSprite.setPosition cc.p(size.width / 2, size.height / 2)
    @backgroundSprite.setScale 0.5
    @addChild @backgroundSprite

    lazyLayer = new cc.LazyLayer()
    @addChild lazyLayer, 5

    @addMenuButton(size)

    # Title sprite
    @addTitleSprite(size)


    # Other sprites
    shipSprite = @addAsShipSprite(size)
    directorSprite = @addAsDirectorSprite(size)

    @addDelayToObject(shipSprite)
    @addDelayToObject(directorSprite)

    @setTouchEnabled true
    @adjustSizeForWindow()
    lazyLayer.adjustSizeForCanvas()
    window.addEventListener "resize", (event) ->
      selfPointer.adjustSizeForWindow()
    true

  adjustSizeForWindow: ->
    margin = document.documentElement.clientWidth - document.body.clientWidth
    if document.documentElement.clientWidth < cc.originalCanvasSize.width
      cc.canvas.width = cc.originalCanvasSize.width
    else
      cc.canvas.width = document.documentElement.clientWidth - margin
    if document.documentElement.clientHeight < cc.originalCanvasSize.height
      cc.canvas.height = cc.originalCanvasSize.height
    else
      cc.canvas.height = document.documentElement.clientHeight - margin
    xScale = cc.canvas.width / cc.originalCanvasSize.width
    yScale = cc.canvas.height / cc.originalCanvasSize.height
    xScale = yScale  if xScale > yScale
    cc.canvas.width = cc.originalCanvasSize.width * xScale
    cc.canvas.height = cc.originalCanvasSize.height * xScale
    parentDiv = document.getElementById("Cocos2dGameContainer")
    if parentDiv
      parentDiv.style.width = cc.canvas.width + "px"
      parentDiv.style.height = cc.canvas.height + "px"
    cc.renderContext.translate 0, cc.canvas.height
    cc.renderContext.scale xScale, xScale
    cc.Director.getInstance().setContentScaleFactor xScale


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
