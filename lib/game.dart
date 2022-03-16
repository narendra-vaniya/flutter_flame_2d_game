import 'dart:io';
import 'package:flame/components.dart';
import 'dart:isolate';
import 'dart:math';
import 'package:flame/flame.dart';
import 'package:flame/game.dart';
import 'package:flame/image_composition.dart';
import 'package:flame/input.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_flame/components/bullet.dart';
import 'package:flutter_flame/components/center_point.dart';
import 'package:flutter_flame/components/enemy.dart';
import 'package:flutter_flame/components/player.dart';
import 'package:just_audio/just_audio.dart';
import 'dart:math' as math;
import 'package:flutter_flame/levels.dart';


// void play(String audio) async {
//   if (kIsWeb) {
//     final player = AudioPlayer();
//     await player.setAsset('assets/audio/bg.mp3');
//     player.load();
//     player.loopMode == LoopMode.all;
//     player.play();
//     return;
//   }
//   if (Platform.isLinux || Platform.isWindows) {
//     Todo: import according to platform 
//     DartVLC.initialize();
//     bool isBg = audio == 'bg.mp3';
//     final player = Player(id: isBg ? 0 : 1);
//     player.add(Media.asset('assets/audio/$audio'));
//     if (audio == 'bg.mp3') {
//       player.setVolume(0.8);
//     }

//     player.playbackStream.listen((event) {
//       if (event.isCompleted) {
//         player.play();
//       }
//     });
//     player.play();
//   }
// }

class MyGame extends FlameGame with PanDetector, HasCollidables {
  ///[vars]
  late Size dSize;
  int levelId = 0;
  Level currentLevel = levels[0];
  Vector2? pointerPos;

  bool isUpdateLevel = false;

  ///[components]
  late ComponentDetails componentDetails;
  CenterPointComponent? centerPoint;
  PlayerComponent? player;
  late SpriteComponent bgComponent,
      bgCenterComponent,
      bgCenterComponent2,
      bgCenterComponent3;

  ///[sprites]
  late Sprite playerSprite, bgSprite, bgCenterSprite, bulletSprite, enemySprite;



  @override
  Future<void>? onLoad() async {
    changeLevel();
    setComponentDetails();

    if (player != null && centerPoint != null) {
      removeAll([player!, centerPoint!]);
    }

    List<Enemy> enemyList = children.whereType<Enemy>().toList();
    List<Bullet> bulletList = children.whereType<Bullet>().toList();

    if (enemyList.isNotEmpty) {
      removeAll(enemyList);
    }
    if (bulletList.isNotEmpty) {
      removeAll(bulletList);
    }

    ///[init img]

    var playerImg = await Flame.images.load('player.png');
    var bgImg = await Flame.images.load('bg.png');
    var bgCenterImg = await Flame.images.load('bg_center.png');
    var enemyImg = await Flame.images.load('enemy.png');
    var bulletImg = await Flame.images.load('bullet.png');

    playerSprite = Sprite(playerImg);
    bgSprite = Sprite(bgImg);
    bgCenterSprite = Sprite(bgCenterImg);
    bulletSprite = Sprite(bulletImg);
    enemySprite = Sprite(enemyImg);
    var bgComponentSize = Vector2(dSize.width, dSize.height);
    var bgCenterSize = min(dSize.height / 2, dSize.width / 2);

    bgComponent = SpriteComponent(sprite: Sprite(bgImg), size: bgComponentSize);
    bgCenterComponent = SpriteComponent(
      sprite: Sprite(bgCenterImg),
      size: Vector2.all(bgCenterSize),
    );
    bgCenterComponent2 = SpriteComponent(
      sprite: Sprite(bgCenterImg),
      size: Vector2.all(bgCenterSize) + Vector2.all(120),
    );
    bgCenterComponent3 = SpriteComponent(
      sprite: Sprite(bgCenterImg),
      size: Vector2.all(bgCenterSize) + Vector2.all(200),
    );
    centerPoint = CenterPointComponent(playerSprite);
    player = PlayerComponent(playerSprite, anchor: Anchor.center);

    await add(bgComponent);
    await add(centerPoint!);
    // if (kIsWeb) {
    //   play("bg.mp3");
    // } else {
    //   Isolate.spawn(play, "bg.mp3");
    // }

    bgCenterComponent.anchor = Anchor.center;
    bgCenterComponent.position = centerPoint!.position;

    bgCenterComponent2.anchor = Anchor.center;
    bgCenterComponent2.position = centerPoint!.position;

    bgCenterComponent3.anchor = Anchor.center;
    bgCenterComponent3.position = centerPoint!.position;

    await add(bgCenterComponent);
    await add(bgCenterComponent2);
    // await add(bgCenterComponent3);
    await centerPoint!.add(player!);

    return super.onLoad();
  }

  @override
  void update(double dt) {
    var random = math.Random();

    bgCenterComponent.transform.angleDegrees += dt * 30;
    bgCenterComponent2.transform.angleDegrees -= dt * 20;
    bgCenterComponent3.transform.angleDegrees += dt * 15;
    Enemy? enemy;
    Bullet? bullet;

    if (pointerPos == null) {
      return super.update(dt);
    }

    var _centerPos = centerPoint!.position;

    ///[ enemy code ]
    var enemyRadius = 10 * math.sqrt(random.nextDouble());
    var theta = random.nextDouble() * 10 * 2 * math.pi;
    var xPos = centerPoint!.x + enemyRadius * math.cos(theta);
    var yPos = centerPoint!.y + enemyRadius * math.sin(theta);
    var enemyPos = Vector2(xPos, yPos);

    enemy = Enemy(enemySprite,
        position: enemyPos, size: Vector2.all(componentDetails.enemySize));

    List<Enemy> enemyList = children.whereType<Enemy>().toList();
    bool isEnemyAdd = enemyList.every(
      (element) =>
          element.position.distanceTo(enemy!.position) >
          componentDetails.enemySpacing,
    );
    if (enemyList.isEmpty) {
      add(enemy);
    }

    if (isEnemyAdd && enemyList.length < componentDetails.totalLengthOfEnemy) {
      add(enemy);
    }

    /// [ bullet code ]
    var bulletAngle = math.atan2(
      _centerPos.x - pointerPos!.x,
      _centerPos.y - pointerPos!.y,
    );
    var bulletRadius = math.min(dSize.height / 2, dSize.width / 2) -
        componentDetails.playerPos;
    var bulletDegrees = (bulletAngle * (180 / math.pi) * -1) + 180;

    var bPosX =
        _centerPos.x + bulletRadius * -math.cos(radians(bulletDegrees - 90));
    var bPosY =
        _centerPos.y + bulletRadius * -math.sin(radians(bulletDegrees - 90));

    bullet = Bullet(
      bulletSprite,
      position: Vector2(bPosX, bPosY),
      angle: centerPoint!.absoluteAngle - 89.5,
    );

    List<Bullet> bulletList = children.whereType<Bullet>().toList();

    if (bulletList.isEmpty) {
      add(bullet);
    }

    bool isAdd = false;

    for (var e in bulletList) {
      if (e.position.distanceTo(bullet.position) >
          componentDetails.bulletSpacing) {
        isAdd = true;
      } else {
        isAdd = false;
      }
    }

    if (isAdd && bulletList.length < componentDetails.totalLengthOfBullet) {
      // Issue: isolate on web 
      // if (!kIsWeb) {
      //   Isolate.spawn(play, "bullet.wav");
      // }
      add(bullet);
    }

    super.update(dt);
  }

  @override
  void onPanUpdate(DragUpdateInfo info) {
    var _centerPos = centerPoint!.position;
    pointerPos = info.eventPosition.global;

    var r = math.atan2(
        -pointerPos!.x + _centerPos.x, -pointerPos!.y + _centerPos.y);
    var d = (r * (180 / math.pi) * -1) + 180;

    centerPoint!.transform.angleDegrees = d;

    super.onPanUpdate(info);
  }

  @override
  void onGameResize(Vector2 canvasSize) {
    dSize = canvasSize.toSize();
    super.onGameResize(canvasSize);
    onLoad();
  }

  bool get isSmall => dSize.width <= 576;
  bool get isMedium => dSize.width > 576 && dSize.width <= 768;
  bool get isLarge => dSize.width > 768;

  void setComponentDetails() {
    if (isSmall) {
      componentDetails = currentLevel.smallDevice;
    }
    if (isMedium) {
      componentDetails = currentLevel.mediumDevice;
    }
    if (isLarge) {
      componentDetails = currentLevel.largeDevice;
    }
  }

  void changeLevel() {}
}
