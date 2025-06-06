import 'package:flame/collisions.dart';

import 'package:flame/components.dart';

import 'package:/flutter/material.dart';

class Bird extends SpriteComponent
    with HasGameReference<FlappyBirdGame>, CollisionCallbacks {
  Vector2 velocity = Vector2.zero();
  @override
  Future<void> onLoad() async {
    await super.onLoad();
    sprite = await gameRef.loadSprite('bird.png');
    position = Vector2(gameRef.size.x / 4, gameRef.size.y / 2);
    size = Vector2(50, 50);
    add(CircleHitbox()..radius = 20);
  }

  @override
  void onCollisionStart(
    Set<Vector2> intersectionPoints,
    PositionComponent other,
  ) {
    super.onCollisionStart(intersectionPoints, other);
    if (other is Pipe) {
      game.Ref.gameOver();
    }
  }
}
