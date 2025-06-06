import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flappy_bird/game/flappy_bird_game.dart';
import 'pipe.dart';
class Bird extends SpriteComponent
    with HasGameReference<FlappyBirdGame>, CollisionCallbacks {
  Vector2 velocity = Vector2.zero();

  @override
  Future<void> onLoad() async {
    sprite = await game.loadSprite('bird.png');
    size = Vector2(50, 50);
    position = Vector2(game.size.x / 4, game.size.y / 2);
    anchor = Anchor.center;
    //debugMode=true;
    add(
      CircleHitbox()
        ..radius = 25
        ..collisionType = CollisionType.active,
    );


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
