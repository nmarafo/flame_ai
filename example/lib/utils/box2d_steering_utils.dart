import 'dart:math';

import 'package:flame_ai/utils/vector_ai.dart';

class Box2dSteeringUtils {

  Box2dSteeringUtils();

  static double vectorToAngle(VectorAI vector) {
    return atan2(-vector.x, vector.y);
  }

  static VectorAI angleToVector(VectorAI outVector, double angle) {
    outVector.x = -sin(angle);
    outVector.y = cos(angle);

    return outVector;
  }
}