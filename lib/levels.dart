List<Level> levels = [
  Level(
    id: 0,
    smallDevice: ComponentDetails(
      bulletSpeed: 155,
      enemySpeed: 50,
      totalLengthOfBullet: 4,
      totalLengthOfEnemy: 3,
      playerPos: 0,
      enemySize: 15,
      bulletSpacing: 120,
      enemySpacing: 80,
    ),
    mediumDevice: ComponentDetails(
      bulletSpeed: 170,
      enemySpeed: 65,
      totalLengthOfBullet: 7,
      totalLengthOfEnemy: 4,
      playerPos: 0,
      enemySize: 20,
      bulletSpacing: 150,
      enemySpacing: 150,
    ),
    largeDevice: ComponentDetails(
      bulletSpeed: 180,
      enemySpeed: 80,
      totalLengthOfBullet: 10,
      totalLengthOfEnemy: 5,
      playerPos: 0,
      enemySize: 30,
      bulletSpacing: 150,
      enemySpacing: 150,
    ),
  ),
];

class Level {
  int id;
  ComponentDetails smallDevice;
  ComponentDetails mediumDevice;
  ComponentDetails largeDevice;
  Level({
    required this.id,
    required this.smallDevice,
    required this.mediumDevice,
    required this.largeDevice,
  });
}

class ComponentDetails {
  double bulletSpeed = 0.0;
  double enemySpeed = 0.0;
  int totalLengthOfBullet = 0;
  int totalLengthOfEnemy = 0;
  int playerPos = 0;
  double enemySize = 20;
  int bulletSpacing = 120;
  int enemySpacing = 120;
  ComponentDetails({
    required this.bulletSpeed,
    required this.enemySpeed,
    required this.totalLengthOfBullet,
    required this.totalLengthOfEnemy,
    required this.playerPos,
    required this.enemySize,
    required this.bulletSpacing,
    required this.enemySpacing,
  });
}
