// Generated by CoffeeScript 1.6.1
(function(){var e;e=window.game||{};e.IntroScreen=cc.Layer.extend({isMouseDown:!1,addDelayToObject:function(e){return this.scheduleOnce(function(){return e.setVisible(!0)},1)},addBackground:function(e){this.backgroundSprite=cc.Sprite.create(s_Splash);this.backgroundSprite.setPosition(cc.p(e.width/2,e.height/2));this.backgroundSprite.setScale(.5);return this.addChild(this.backgroundSprite)},addTitleSprite:function(e){this.titleSprite=cc.Sprite.create(s_Title_TitleText);this.titleSprite.setPosition(cc.p(e.width/2,0));this.titleSprite.setScale(.5);this.addChild(this.titleSprite,10);return this.titleSprite.runAction(cc.MoveBy.create(.8,cc.p(0,e.height-210)))},addAsShipSprite:function(e){var t;t=cc.MenuItemImage.create(s_Title_AsShip,s_Title_AsShip,this.onNewAsShip);t.setScale(.5);t.setVisible(!1);this.addDelayToObject(t);return t},addAsDirectorSprite:function(e){var t;t=cc.MenuItemImage.create(s_Title_AsDirector,s_Title_AsDirector,this.onNewAsDirector);t.setAnchorPoint(cc.p(.5,.5));t.setScale(.5);t.setVisible(!1);this.addDelayToObject(t);return t},addMenuButton:function(e){var t;t=cc.Menu.create(this.addAsShipSprite(e),this.addAsDirectorSprite(e));t.alignItemsVerticallyWithPadding(10);t.setPosition(e.width/2,e.height/2-160);return this.addChild(t,5,2)},init:function(){var e,t,n;t=this;this._super();n=cc.Director.getInstance().getWinSize();this.addBackground(n);e=new cc.LazyLayer;this.addChild(e,2);this.addTitleSprite(n);this.addMenuButton(n);this.setTouchEnabled(!0);return!0},onNewAsShip:function(e){return console.log("new ship game")},onNewAsDirector:function(e){return console.log("new director game")}});e.IntroScreenScene=cc.Scene.extend({onEnter:function(){var t;this._super();t=new e.IntroScreen;t.init();return this.addChild(t)}})}).call(this);