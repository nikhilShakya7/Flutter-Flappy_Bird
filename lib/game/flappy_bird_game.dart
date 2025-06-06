import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flame/input.dart';
import 'package:flame/parallax.dart';
import 'package:flappy_bird/game/components/bird.dart';
import 'package:flappy_bird/game/components/pipe.dart';
import 'package:flutter/material.dart';

class FlappyBirdGame extends FlameGame with TapDetector, HasCollisionDetection {
  late Bird bird;
  late TextComponent scoreText;
  int score = 0;
  bool isGameOver = false;

  final double gravity = 400;
  final double jumpForce = -200;

  double pipeInterval = 2.3;
  double timeSinceLastPipe = 0.0;

  @override
  Future<void> onLoad() async {
    await super.onLoad();


    final parallax = await loadParallaxComponent(
      [
        ParallaxImageData('background.jpg'),
      ],
      baseVelocity: Vector2(40, 0),
      repeat: ImageRepeat.repeat,
    );
    add(parallax);

    bird = Bird();
    add(bird);

    scoreText = TextComponent(
      text: 'Score: 0',
      position: Vector2(size.x / 2, 30),
      anchor: Anchor.topCenter,
      priority: 1,
      textRenderer: TextPaint(
        style: const TextStyle(
          color: Colors.white,
          fontSize: 24,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
    add(scoreText);
  }

  @override
  void onTap() {
    if (isGameOver) {
      resetGame();
    } else {
      bird.velocity.y = jumpForce;
    }
  }

  @override
  void update(double dt) {
    super.update(dt);

    if (isGameOver) return;

    bird.velocity.y += gravity * dt;
    bird.position += bird.velocity * dt;

    timeSinceLastPipe += dt;
    if (timeSinceLastPipe > pipeInterval) {
      timeSinceLastPipe = 0;
      add(PipePair());
    }

    if (bird.position.y > size.y || bird.position.y < 0) {
      gameOver();
    }
  }

  void increaseScore() {
    score++;
    scoreText.text = 'Score: $score';
  }

  void gameOver() {
    if (isGameOver) return;
    isGameOver = true;
    bird.velocity.y = 0;

    pauseEngine(); // ⛔️ Freeze the game

    final gameOverText = TextComponent(
      text: 'Game Over!\nTap to restart',
      position: size / 2,
      anchor: Anchor.center,
      priority: 1,
      textRenderer: TextPaint(
        style: const TextStyle(
          color: Colors.white,
          fontSize: 32,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
    add(gameOverText);

  }


  void resetGame() {
    score = 0;
    isGameOver = false;
    scoreText.text = 'Score: 0';

    bird.position = Vector2(size.x / 4, size.y / 2);
    bird.velocity = Vector2.zero();


    children.whereType<PipePair>().toList().forEach(remove);
    children
        .whereType<TextComponent>()
        .where((t) => t.text.contains('Game Over'))
        .toList()
        .forEach(remove);


    resumeEngine();
  }

}
