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
    message = undefined
    if @_won
      message = "You Won!"
    else
      message = "You Lose :["
    label = cc.LabelTTF.create(message, "Arial", 32)
    label.setColor cc.c3b(0, 0, 0)
    label.setPosition winSize.width / 2, winSize.height / 2
    @addChild label
    @runAction cc.Sequence.create(cc.DelayTime.create(3), cc.CallFunc.create((node) ->
      scene = new game.IntroScreenScene()
      cc.Director.getInstance().replaceScene scene
    , this))
)
game.GameOver.create = (won) ->
  sg = new game.GameOver()
  sg._won = won
  return sg  if sg and sg.init(cc.c4b(255, 255, 255, 255))
  null

game.GameOver.scene = (won = true) ->
  scene = cc.Scene.create()
  layer = game.GameOver.create(won)
  scene.addChild layer
  scene
