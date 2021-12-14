import 'package:flame_ai_example/ai/player_ai.dart';
import 'package:flame_forge2d/flame_forge2d.dart';

class PlayerComponent {

  static final int IDLE = 0;
  static final int IDLE_UP = 0;
  static final int IDLE_DOWN = 1;
  static final int IDLE_LEFT = 2;
  static final int IDLE_RIGHT = 3;

  static final int MOVE_UP = 4;
  static final int MOVE_DOWN = 5;
  static final int MOVE_LEFT = 6;
  static final int MOVE_RIGHT = 7;
  static final int DIE = 8;

  late PlayerAI ai;

  final Body body;

  late int currentState;

  late int hp;

  late double invincibleTimer;

  PlayerComponent(this.body) {
    ai = new PlayerAI(body);
    currentState = IDLE_RIGHT;
    hp = 1;
    invincibleTimer = 0;
  }

  Body getBody() {
    return body;
  }
}