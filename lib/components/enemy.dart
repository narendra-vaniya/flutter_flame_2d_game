import 'dart:math' as math;
import 'package:flame/components.dart';
import 'package:flame/geometry.dart';
import 'package:flutter_flame/components/bullet.dart';
import 'package:flutter_flame/game.dart';

class Enemy extends SpriteComponent
    with HasGameRef<MyGame>, HasHitboxes, Collidable {
  int heath = 1;
  var random = math.Random();
  late Vector2 endPos;

  Enemy(
    Sprite sprite, {
    Vector2? position,
    Vector2? size,
    Vector2? scale,
    double? angle,
    Anchor? anchor,
    int? priority,
    this.heath = 1,
  }) : super(
          sprite: sprite,
          position: position,
          size: size ?? Vector2(25,25),
          scale: scale,
          angle: angle,
          anchor: Anchor.center,
          priority: priority,
        ) {
    addHitbox(HitboxCircle());
  }
  @override
  Future<void>? onLoad() {
    var r = math.min(gameRef.dSize.height / 2, gameRef.dSize.width / 2) *
            math.sqrt(1) -
        gameRef.componentDetails.playerPos;
    var theta = random.nextDouble() * 10 * 2 * math.pi;
    var xPos = gameRef.centerPoint!.x + r * math.cos(theta);
    var yPos = gameRef.centerPoint!.y + r * math.sin(theta);
    endPos = Vector2(xPos, yPos);
    return super.onLoad();
  }

  @override
  void update(double dt) {
    super.update(dt);

    position.moveToTarget(
        endPos, random.nextDouble() * gameRef.componentDetails.enemySpeed * dt);
    var isRemove = position.distanceTo(endPos) <= 0;
    if (isRemove) {
      // gameRef.pauseEngine();
      gameRef.remove(this);
    }
  }

  @override
  void onCollision(Set<Vector2> intersectionPoints, Collidable other) {
    super.onCollision(intersectionPoints, other);
    if (other is Bullet) {
      if (heath > 0) {
        heath -= 1;
      }
    }
  }
}
