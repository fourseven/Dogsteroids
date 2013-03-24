window.game = window.game || {}

game.GameOver = cc.LayerColor.extend(
  _won: false
  ctor: ->
    @_super()
    cc.associateWithNative this, cc.LayerColor

  onEnter: ->
    @_super()
    director = cc.Director.getInstance()
    winSize = director.getWinSize()
    centerPos = cc.p(winSize.width / 2, winSize.height / 2)

    @backgroundSprite = cc.Sprite.create(s_Splash)
    @backgroundSprite.setPosition cc.p(winSize.width / 2, winSize.height / 2)
    @backgroundSprite.setScale 0.5
    @addChild @backgroundSprite
    sprite = undefined

    if @_won
      sprite = cc.Sprite.create(s_Win_Screen)
      sprite.setPosition cc.p(winSize.width / 2, winSize.height / 2)
    else
      sprite = cc.Sprite.create(s_Lose_Screen)
      sprite.setPosition cc.p(winSize.width / 2, winSize.height / 2 - 150)
      @addCatsToGo(winSize)

    sprite.setScale 0.5
    sprite.setPosition centerPos
    @addChild sprite
    @runAction cc.Sequence.create(cc.DelayTime.create(3), cc.CallFunc.create((node) ->
      scene = new game.IntroScreenScene()
      cc.Director.getInstance().replaceScene scene
    , this))

  addCatsToGo: (winSize) ->
    ctg = cc.Sprite.create(s_Cats_To_Go)
    ctg.setPosition cc.p(winSize.width / 2, winSize.height / 2 + 150)
    @addChild ctg


)
game.GameOver.create = (won) ->
  sg = new game.GameOver()
  sg._won = won
  return sg  if sg and sg.init(cc.c4b(0, 0, 0, 255))
  null

game.GameOver.scene = (won = true) ->
  scene = cc.Scene.create()
  layer = game.GameOver.create(won)
  scene.addChild layer
  scene
