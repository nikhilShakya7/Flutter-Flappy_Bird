import 'dart:math';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flappy_bird/game/components/bird.dart';
import 'package:flappy_bird/game/flappy_bird_game.dart';
import 'package:flutter/material.dart';

class PipePair extends PositionComponent with HasGameRef<FlappyBirdGame> {
  @override
  Future<void> onLoad() async {
    await super.onLoad();

    final gapSize = 200.0;
    final gapPosition =
        gameRef.size.y / 2 + (Random().nextDouble() * 200 - 100);

    add(
      Pipe(
        position: Vector2(0, gapPosition - gapSize / 2 - 320),
        size: Vector2(70, 320),
        isTop: true,
        gameRef: gameRef,
      ),
    );

    add(
      Pipe(
        position: Vector2(0, gapPosition + gapSize / 2),
        size: Vector2(70, 320),
        isTop: false,
        gameRef: gameRef,
      ),
    );

    position = Vector2(gameRef.size.x, 0);

    // Score zone
    add(
      ScoreZone(
        position: Vector2(70, gapPosition - gapSize / 2),
        size: Vector2(10, gapSize),
        gameRef: gameRef,
      ),
    );
  }

  @override
  void update(double dt) {
    super.update(dt);
    position.x -= 100 * dt;

    if (position.x < -100) {
      removeFromParent();
    }
  }
}

class Pipe extends SpriteComponent with CollisionCallbacks {
  final bool isTop;
  final FlappyBirdGame gameRef;

  Pipe({
    required super.position,
    required super.size,
    required this.isTop,
    required this.gameRef,
  });

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    sprite = await gameRef.loadSprite(
      isTop ? 'pipe_top.png' : 'pipe_bottom.png',
    );
    anchor = Anchor.topLeft;
    add(RectangleHitbox());
  }
}

class ScoreZone extends PositionComponent with CollisionCallbacks {
  final FlappyBirdGame gameRef;

  ScoreZone({
    required super.position,
    required super.size,
    required this.gameRef,
  });

  @override
  void onCollisionStart(
    Set<Vector2> intersectionPoints,
    PositionComponent other,
  ) {
    super.onCollisionStart(intersectionPoints, other);
    if (other is Bird) {
      gameRef.increaseScore();
      removeFromParent();
    }
  }
}
