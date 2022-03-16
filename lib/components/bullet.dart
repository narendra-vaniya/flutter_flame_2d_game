import 'package:flame/components.dart';
import 'package:flame/geometry.dart';
import 'package:flutter_flame/components/enemy.dart';
import 'package:flutter_flame/game.dart';

class Bullet extends SpriteComponent
    with HasGameRef<MyGame>, HasHitboxes, Collidable {
  Bullet(
    Sprite sAnimation, {
    Vector2? position,
    Vector2? size,
    Vector2? scale,
    double? angle,
    Anchor? anchor,
    int? priority,
  }) : super(
          sprite: sAnimation,
          position: position,
          size: size ?? Vector2(30, 50),
          scale: scale,
          angle: angle,
          anchor: Anchor.center,
          priority: priority,
        ) {
    addHitbox(HitboxCircle());
  }
  @override
  Future<void>? onLoad() {
    return super.onLoad();
  }

  @override
  void update(double dt) {
    var pos = gameRef.centerPoint!.position;
    position.moveToTarget(pos, dt * gameRef.componentDetails.bulletSpeed);

    var isRemove = position.distanceTo(pos) <= 0;
    if (isRemove) {
      gameRef.remove(this);
    }
    super.update(dt);
  }

  @override
  void onCollision(Set<Vector2> intersectionPoints, Collidable other) {
    if (other is Enemy) {
      gameRef.remove(this);
      if (other.heath <= 0) {
        gameRef.remove(other);
      }
    }
    super.onCollision(intersectionPoints, other);
  }
}
