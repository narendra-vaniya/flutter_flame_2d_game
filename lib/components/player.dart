import 'dart:math';

import 'package:flame/components.dart';
import 'package:flutter/material.dart';
import 'package:flutter_flame/game.dart';

class PlayerComponent extends SpriteComponent with HasGameRef<MyGame> {
  PlayerComponent(
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
          size: size ?? Vector2.all(30),
          scale: scale,
          angle: 0,
          anchor: Anchor.center,
          priority: priority,
        );

  @override
  Future<void>? onLoad() {
   
    y += min(gameRef.dSize.height/2,gameRef.dSize.width/2)- gameRef.componentDetails.playerPos;
    x += 7;
    
    return super.onLoad();
  }
}
