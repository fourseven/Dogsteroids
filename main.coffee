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
window.game = window.game || {}
cocos2dApp = cc.Application.extend(
  config: document["ccConfig"]
  ctor: (scene) ->
    @_super()
    @startScene = scene
    cc.COCOS2D_DEBUG = @config["COCOS2D_DEBUG"]
    cc.initDebugSetting()
    cc.setup @config["tag"]
    cc.AppController.shareAppController().didFinishLaunchingWithOptions()

  applicationDidFinishLaunching: ->

    # initialize director
    director = cc.Director.getInstance()

    # enable High Resource Mode(2x, such as iphone4) and maintains low resource on other devices.
    #director.enableRetinaDisplay(true);

    # turn on display FPS
    director.setDisplayStats @config["showFPS"]

    # set FPS. the default value is 1.0/60 if you don't call this
    director.setAnimationInterval 1.0 / @config["frameRate"]

    #load resources
    cc.Loader.preload g_ressources, (->
      cc.Director.getInstance().replaceScene new @startScene()
    ), this
    true
)
myApp = new cocos2dApp(game.IntroScreenScene)
