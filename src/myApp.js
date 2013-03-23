// Generated by CoffeeScript 1.6.1
(function() {

  window.game = window.game || {};

  /*
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
  */


  game.CircleSprite = cc.Sprite.extend({
    _radians: 0,
    ctor: function() {
      return this._super();
    },
    draw: function() {
      cc.renderContext.fillStyle = "rgba(255,255,255,1)";
      cc.renderContext.strokeStyle = "rgba(255,255,255,1)";
      if (this._radians < 0) {
        this._radians = 360;
      }
      return cc.drawingUtil.drawCircle(cc.PointZero(), 30, cc.DEGREES_TO_RADIANS(this._radians), 60, true);
    },
    myUpdate: function(dt) {
      return this._radians -= 6;
    }
  });

  game.Helloworld = cc.Layer.extend({
    isMouseDown: false,
    helloImg: null,
    helloLabel: null,
    addDelayToObject: function(object) {
      return this.scheduleOnce(function() {
        return object.setVisible(true);
      }, 1.0);
    },
    addBackground: function(size) {
      this.backgroundSprite = cc.Sprite.create(s_Splash);
      this.backgroundSprite.setPosition(cc.p(size.width / 2, size.height / 2));
      this.backgroundSprite.setScale(0.5);
      return this.addChild(this.backgroundSprite);
    },
    addTitleSprite: function(size) {
      this.titleSprite = cc.Sprite.create(s_Title_TitleText);
      this.titleSprite.setPosition(cc.p(size.width / 2, 0));
      this.titleSprite.setScale(0.5);
      this.addChild(this.titleSprite, 10);
      return this.titleSprite.runAction(cc.MoveBy.create(0.8, cc.p(0, size.height - 210)));
    },
    addAsShipSprite: function(size) {
      var asShipSprite;
      asShipSprite = cc.MenuItemImage.create(s_Title_AsShip, s_Title_AsShip, this.onNewAsShip);
      asShipSprite.setScale(0.5);
      asShipSprite.setVisible(false);
      this.addDelayToObject(asShipSprite);
      return asShipSprite;
    },
    addAsDirectorSprite: function(size) {
      var asDirectorSprite;
      asDirectorSprite = cc.MenuItemImage.create(s_Title_AsDirector, s_Title_AsDirector, this.onNewAsDirector);
      asDirectorSprite.setAnchorPoint(cc.p(0.5, 0.5));
      asDirectorSprite.setScale(0.5);
      asDirectorSprite.setVisible(false);
      this.addDelayToObject(asDirectorSprite);
      return asDirectorSprite;
    },
    addMenuButton: function(size) {
      var menu;
      menu = cc.Menu.create(this.addAsShipSprite(size), this.addAsDirectorSprite(size));
      menu.alignItemsVerticallyWithPadding(10);
      menu.setPosition(size.width / 2, size.height / 2 - 160);
      return this.addChild(menu, 5, 2);
    },
    init: function() {
      var lazyLayer, selfPointer, size;
      selfPointer = this;
      this._super();
      size = cc.Director.getInstance().getWinSize();
      this.addBackground(size);
      lazyLayer = new cc.LazyLayer();
      this.addChild(lazyLayer, 2);
      this.addTitleSprite(size);
      this.addMenuButton(size);
      this.setTouchEnabled(true);
      return true;
    },
    onNewAsShip: function(sender) {
      return console.log("new ship game");
    },
    onNewAsDirector: function(sender) {
      return console.log("new director game");
    },
    menuCloseCallback: function(sender) {
      return cc.Director.getInstance().end();
    },
    onTouchesBegan: function(touches, event) {
      return this.isMouseDown = true;
    },
    onTouchesMoved: function(touches, event) {
      if (this.isMouseDown) {
        return touches;
      }
    },
    onTouchesEnded: function(touches, event) {
      return this.isMouseDown = false;
    },
    onTouchesCancelled: function(touches, event) {
      return console.log("onTouchesCancelled");
    }
  });

  game.HelloWorldScene = cc.Scene.extend({
    onEnter: function() {
      var layer;
      this._super();
      layer = new game.Helloworld();
      layer.init();
      return this.addChild(layer);
    }
  });

}).call(this);