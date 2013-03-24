// Generated by CoffeeScript 1.6.1
(function() {
  var Asteroid, PlayerShip, PlayerShipBullet, _ref;

  window.game = window.game || {};

  game.ShipMainScreen = cc.LayerColor.extend({
    _shipSprite: null,
    _bulletArray: [],
    _asteroidArray: [],
    ctor: function() {
      this._super(new cc.Color4B(0, 0, 0, 255));
      this._shipSprite = new PlayerShip(this);
      this.setTouchEnabled(true);
      this.setKeyboardEnabled(true);
      this.setPosition(new cc.Point(0, 0));
      this._bulletArray = [];
      this._asteroidArray = [];
      this.addChild(this._shipSprite);
      this._shipSprite.scheduleUpdate();
      this.schedule(this.update);
      return true;
    },
    onEnter: function() {
      this._super();
      return this.schedule(this.gameLogic, 3);
    },
    gameLogic: function() {
      return this.addAsteroid();
    },
    update: function(dt) {
      for (var j = 0; j < this._asteroidArray.length; j++) {
      var asteroid = this._asteroidArray[j];
      var asteroidRect = asteroid.getBoundingBox();
      for (var i = 0; i < this._bulletArray.length; i++) {
        var bullet = this._bulletArray[i];
        var bulletRect = bullet.getBoundingBox();
        if (cc.rectContainsRect(bulletRect, asteroidRect)) {
            cc.log("collision!");
            cc.ArrayRemoveObject(this._bulletArray, bullet);
            bullet.removeFromParent();
            cc.ArrayRemoveObject(this._asteroidArray, asteroid);
            asteroid.removeFromParent();
        }
      }
      var scene;
      var intersection = cc.rectIntersection(asteroidRect, this._shipSprite.getBoundingBox());
      if (intersection.size.width > 2 && intersection.size.height > 2) {
        this._asteroidArray = [];
        this._bulletArray = [];
        scene = game.GameOver.scene(false);
        cc.Director.getInstance().replaceScene(scene);
      }
    };
    },
    onTouchesEnded: function(pTouch, pEvent) {},
    onTouchesMoved: function(pTouch, pEvent) {
      return this._shipSprite.handleTouchMove(pTouch[0].getLocation());
    },
    onKeyUp: function(e) {},
    onKeyDown: function(e) {
      return this._shipSprite.handleKey(e);
    },
    addAsteroid: function() {
      var asteroid;
      asteroid = new Asteroid();
      this.addChild(asteroid);
      return this._asteroidArray.push(asteroid);
    },
    fireBullet: function(position, currentRotation) {
      var bullet;
      bullet = new PlayerShipBullet(this._shipSprite.getPosition(), this._shipSprite.getCurrentRotation());
      this.addChild(bullet);
      this._bulletArray.push(bullet);
      return bullet.runAction(bullet.actionMove(), function() {
        return cc.CallFunc.create(function(node) {
          cc.ArrayRemoveObject(this._bulletArray, node);
          return node.removeFromParent();
        }, this);
      });
    }
  });

  game.ShipMainScreenScene = cc.Scene.extend({
    onEnter: function() {
      this._super();
      return this.addChild(new game.ShipMainScreen());
    }
  });

  PlayerShip = cc.Sprite.extend({
    ROTATION_VECTOR: 15,
    _currentVelocity: 0,
    _currentRotation: 90,
    _position: null,
    _size: null,
    _scene: null,
    ctor: function(scene) {
      this._super();
      this._scene = scene;
      this.initWithFile(s_Ship_Stationary);
      this._size = cc.Director.getInstance().getWinSize();
      this._position = new cc.Point(this._size.width / 2, this._size.height / 2);
      return this.setPosition(this._position);
    },
    update: function(dt) {
      this.setRotation(this._currentRotation - 90);
      return this.moveShip();
    },
    getPosition: function() {
      return this._position;
    },
    getCurrentRotation: function() {
      return this._currentRotation;
    },
    handleKey: function(e) {
      if (e === cc.KEY.left) {
        this._currentRotation = this._currentRotation - this.ROTATION_VECTOR;
      }
      if (e === cc.KEY.right) {
        this._currentRotation = this._currentRotation + this.ROTATION_VECTOR;
      }
      if (e === cc.KEY.up) {
        this._currentVelocity += 1;
      }
      if (e === cc.KEY.down) {
        this._currentVelocity -= 1;
      }
      if (e === cc.KEY.space) {
        this._scene.fireBullet();
      }
      if (this._currentVelocity > 10) {
        this._currentVelocity = 10;
      }
      if (this._currentVelocity < -10) {
        this._currentVelocity = -10;
      }
      if (this._currentRotation < 0) {
        this._currentRotation = 360;
      }
      if (this._currentRotation > 360) {
        return this._currentRotation = 0;
      }
    },
    handleTouchMove: function(touchLocation) {
      var angle;
      angle = Math.atan2(touchLocation.x - 300, touchLocation.y - 300);
      angle = angle * (180 / Math.PI);
      return this._currentRotation = angle;
    },
    moveShip: function() {
      var xChange, yChange;
      xChange = this._currentVelocity * Math.cos(this._currentRotation * Math.PI / 180);
      yChange = this._currentVelocity * Math.sin(this._currentRotation * Math.PI / 180);
      this._position.x -= xChange;
      this._position.y += yChange;
      this.sanitizeX();
      this.sanitizeY();
    },
    sanitizeX: function() {
      var maxX;
      maxX = this._size.width + this.getBoundingBox().width / 2;
      if (this._position.x > maxX) {
        this._position.x = this._position.x % maxX;
      }
      if (this._position.x < -this.getBoundingBox().width / 2) {
        return this._position.x = maxX;
      }
    },
    sanitizeY: function() {
      var maxY;
      maxY = this._size.height + this.getBoundingBox().height / 2;
      if (this._position.y > maxY) {
        this._position.y = this._position.y % maxY;
      }
      if (this._position.y < -this.getBoundingBox().height / 2) {
        return this._position.y = maxY;
      }
    }
  });

  PlayerShipBullet = cc.Sprite.extend({
    BULLET_VELOCITY: 12,
    LONGEST_LENGTH: 0,
    _angle: null,
    _position: null,
    _rotation: (_ref = Math.round(Math.random()) === 0) != null ? _ref : {
      20: -20
    },
    _currentRotation: Math.floor(Math.random() * (360 + 1)),
    ctor: function(sourcePosition, angle) {
      this._super();
      this.initWithFile(s_Ship_Bullet);
      this._size = cc.Director.getInstance().getWinSize();
      this._position = new cc.Point(sourcePosition.x, sourcePosition.y);
      this.LONGEST_LENGTH = Math.sqrt((this._size.width * this._size.width) + (this._size.height * this._size.height));
      this._angle = angle - 90;
      this.setPosition(this._position);
      this.createMovement;
      return this.schedule(function() {
        this.rotateBullet();
        return this.setRotation(this._currentRotation);
      });
    },
    actionMove: function() {
      var duration;
      duration = this.calculateDuration();
      return cc.MoveTo.create(duration, this.cacluateEndPosition());
    },
    rotateBullet: function() {
      this._currentRotation = this._currentRotation + this._rotation;
      return this._currentRotation = this._currentRotation % 360;
    },
    calculateDuration: function() {
      var duration;
      duration = this.LONGEST_LENGTH / 60 / this.BULLET_VELOCITY;
      return duration;
    },
    cacluateEndPosition: function() {
      var finalX, finalY;
      finalX = this.LONGEST_LENGTH * Math.sin(this._angle * Math.PI / 180) + this._position.x;
      finalY = this.LONGEST_LENGTH * Math.cos(this._angle * Math.PI / 180) + this._position.y;
      return new cc.Point(finalX, finalY);
    }
  });

  Asteroid = cc.Sprite.extend({
    VELOCITY: 4,
    _angle: 0,
    _position: null,
    _size: null,
    _rotation: 0,
    _currentRotation: 0,
    ctor: function() {
      this._super();
      this.initWithFile(s_Asteroid_Large);
      this._size = cc.Director.getInstance().getWinSize();
      this._position = this.makePosition();
      this._rotation = Math.floor(Math.random() * (20 + 1)) - 10;
      this._angle = Math.floor(Math.random() * (360 + 1));
      this._currentRotation = Math.floor(Math.random() * (360 + 1));
      return this.schedule(function() {
        this.moveAsteroid();
        this.rotateAsteroid();
        this.setPosition(this._position);
        return this.setRotation(this._currentRotation);
      });
    },
    makePosition: function() {
      var side;
      side = Math.floor(Math.random() * 3.);
      if (side === 0) {
        return new cc.Point(this._size.width / 2, this._size.height + 10);
      }
      if (side === 1) {
        return new cc.Point(this._size.width + 10, this._size.height / 2);
      }
      if (side === 2) {
        return new cc.Point(this._size.width / 2, -10);
      }
      if (side === 3) {
        return new cc.Point(-10, this._size.height / 2);
      }
    },
    moveAsteroid: function() {
      var xChange, yChange;
      xChange = this.VELOCITY * Math.cos(this._angle * Math.PI / 180);
      yChange = this.VELOCITY * Math.sin(this._angle * Math.PI / 180);
      this._position.x -= xChange;
      this._position.y += yChange;
      this.sanitizeX();
      this.sanitizeY();
    },
    rotateAsteroid: function() {
      this._currentRotation = this._currentRotation + this._rotation;
      return this._currentRotation = this._currentRotation % 360;
    },
    sanitizeX: function() {
      var maxX;
      maxX = this._size.width + this.getBoundingBox().width / 2;
      if (this._position.x > maxX) {
        this._position.x = this._position.x % maxX;
      }
      if (this._position.x < -this.getBoundingBox().width / 2) {
        return this._position.x = maxX;
      }
    },
    sanitizeY: function() {
      var maxY;
      maxY = this._size.height + this.getBoundingBox().height / 2;
      if (this._position.y > maxY) {
        this._position.y = this._position.y % maxY;
      }
      if (this._position.y < -this.getBoundingBox().height / 2) {
        return this._position.y = maxY;
      }
    }
  });

}).call(this);
