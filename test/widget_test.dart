import 'package:flame/game.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:flappy_bird/game/flappy_bird_game.dart';

void main() {
  testWidgets('FlappyBirdGame loads', (WidgetTester tester) async {
    final game = FlappyBirdGame();
    await tester.pumpWidget(GameWidget(game: game));

    expect(find.byType(GameWidget), findsOneWidget);
  });
}
