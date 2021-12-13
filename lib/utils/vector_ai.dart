import 'package:flame/extensions.dart';
import 'package:flame_ai/steer/steerable.dart';

class VectorAI extends Vector2{
  late Steerable owner;
  VectorAI(): super.zero();
  VectorAI.owner(this.owner):super.zero();
}