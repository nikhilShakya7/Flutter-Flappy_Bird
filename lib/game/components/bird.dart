import 'dart:io';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flappy_bird/game/flappy_bird_game.dart';

class Bird extends SpriteComponent
    with HasGameReference<FlappyBirdGame>, CollisionCallbacks {
  Vector2 velocity = Vector2.zero();

  @override
  Future<void> onLoad() async {
    sprite = await game.loadSprite('bird.png');
    position = Vector2(game.size.x / 4, game.size.y / 2);
    size = Vector2(50, 50);
    anchor = Anchor.center;

    add(CircleHitbox()..radius = 20);
  }

  @override
  void onCollisionStart(
    Set<Vector2> intersectionPoints,
    PositionComponent other,
  ) {
    super.onCollisionStart(intersectionPoints, other);
    if (other is Pipe) {
      game.gameOver();
    }
  }
}
