
import 'dart:ui';

import 'package:flame/components.dart';
import 'package:flame/input.dart';
import 'package:flame_forge2d/flame_forge2d.dart';
import 'package:flame_forge2d/forge2d_game.dart';
import 'package:flame_forge2d/position_body_component.dart';
import 'package:forge2d/forge2d.dart';

import 'package:flutter/material.dart' hide Image;
import 'package:flutter/services.dart';

import 'package:flame_ai_example/boundaries.dart';
import 'package:flame_ai_example/commons/ember.dart';


class ChopperBody extends PositionBodyComponent {
  final Vector2 position;

  ChopperBody(
      this.position,
      PositionComponent component,
      ) : super(positionComponent: component, size: component.size);

  @override
  Body createBody() {
    final shape = CircleShape()..radius = size.x / 4;
    final fixtureDef = FixtureDef(shape)
      ..userData = this // To be able to determine object in collision
      ..restitution = 0.8
      ..density = 1.0
      ..friction = 0.2;

    final velocity = (Vector2.random() - Vector2.random()) * 200;
    final bodyDef = BodyDef()
      ..position = position
      ..angle = velocity.angleTo(Vector2(1, 0))
      ..linearVelocity = velocity
      ..type = BodyType.dynamic;
    return world.createBody(bodyDef)..createFixture(fixtureDef);
  }
}

class PlayerBody extends PositionBodyComponent {
  final Vector2 position;

  PlayerBody(
      this.position,
      PositionComponent component,
      ) : super(positionComponent: component, size: component.size);
  PlayerBody.alone(this.position);

  @override
  Body createBody() {
    final shape = CircleShape()..radius = size.x / 4;
    final fixtureDef = FixtureDef(shape)
      ..userData = this // To be able to determine object in collision
      ..restitution = 0.8
      ..density = 1.0
      ..friction = 0.2;

    final velocity = (Vector2.random() - Vector2.random()) * 200;
    final bodyDef = BodyDef()
      ..position = position
      ..angle = velocity.angleTo(Vector2(1, 0))
      ..linearVelocity = velocity
      ..type = BodyType.dynamic;
    return world.createBody(bodyDef)..createFixture(fixtureDef);
  }
}

class PositionBodySample extends Forge2DGame with TapDetector,KeyboardEvents {
  static const int speed = 100;

  late Image chopper;
  late Image playerImage;
  late SpriteAnimation animation;
  late SpriteAnimation playerAnimation;
  late Body bodyPlayer;
  late PlayerBody playerBody;
  //late final Ember ember;

  PositionBodySample() : super(gravity: Vector2.zero());

  final Vector2 velocity = Vector2(0, 0);

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    chopper = await images.load('animations/chopper.png');
    playerImage = await images.load('animations/ember.png');
    //ember = Ember(position: size / 2, size: Vector2.all(10));

    animation = SpriteAnimation.fromFrameData(
      chopper,
      SpriteAnimationData.sequenced(
        amount: 4,
        textureSize: Vector2.all(48),
        stepTime: 0.15,
      ),
    );

    final boundaries = createBoundaries(this);
    boundaries.forEach(add);
    //add(ember);
  }

  @override
  void onMount() {
    super.onMount();
    playerAnimation = SpriteAnimation.fromFrameData(
      playerImage,
      SpriteAnimationData.sequenced(
        amount: 3,
        textureSize: Vector2.all(16),
        stepTime: 0.15,
      ),
    );

    final playerAnimationComponent = SpriteAnimationComponent(
      animation: playerAnimation,
      size: Vector2.all(10),
    );

    playerBody=PlayerBody(Vector2.zero(), playerAnimationComponent);
    add(playerBody);
  }

  @override
  void update(double dt) {
    super.update(dt);
    final displacement = velocity * (speed * dt);
    //ember.position.add(displacement);
  }

  @override
  void onTapDown(TapDownInfo details) {
    super.onTapDown(details);
    final position = details.eventPosition.game;
    final spriteSize = Vector2.all(10);
    final animationComponent = SpriteAnimationComponent(
      animation: animation,
      size: spriteSize,
    );
    add(ChopperBody(position, animationComponent));
  }

  @override
  KeyEventResult onKeyEvent(
      RawKeyEvent event,
      Set<LogicalKeyboardKey> keysPressed,
      ) {
    final isKeyDown = event is RawKeyDownEvent;

    if (event.logicalKey == LogicalKeyboardKey.keyA) {
      //velocity.x = isKeyDown ? -1 : 0;
     playerBody.body.applyLinearImpulse(Vector2(-40.0,0.0));
    } else if (event.logicalKey == LogicalKeyboardKey.keyD) {
      playerBody.body.applyLinearImpulse(Vector2(40.0,0.0));
    } else if (event.logicalKey == LogicalKeyboardKey.keyW) {
      playerBody.body.applyLinearImpulse(Vector2(0.0,40.0));
    } else if (event.logicalKey == LogicalKeyboardKey.keyS) {
      playerBody.body.applyLinearImpulse(Vector2(0.0,-40.0));
    }

    return super.onKeyEvent(event, keysPressed);
  }
}