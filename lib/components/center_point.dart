import 'package:flame/components.dart';
import 'package:flutter_flame/game.dart';

class CenterPointComponent extends SpriteComponent with HasGameRef<MyGame> {
  CenterPointComponent(
    Sprite sprite, {
    Vector2? position,
    Vector2? size,
    Vector2? scale,
    double? angle,
    Anchor? anchor,
    int? priority,
  }) : super(
          sprite: sprite,
          position: position,
          size: size ?? Vector2.all(0.1),
          scale: scale,
          angle: angle,
          anchor: Anchor.center,
          priority: priority,
        );

  @override
  Future<void>? onLoad() {
    position = Vector2(
          gameRef.dSize.width / 2,
          gameRef.dSize.height / 2,
        ) -
        Vector2.all(1);
      
    return super.onLoad();
  }
}
