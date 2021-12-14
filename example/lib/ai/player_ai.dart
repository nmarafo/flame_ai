import 'package:flame_ai/utils/location.dart';
import 'package:flame_ai/utils/vector_ai.dart';
import 'package:flame_ai_example/utils/box2d_location.dart';
import 'package:flame_ai_example/utils/box2d_steering_utils.dart';
import 'package:flame_forge2d/flame_forge2d.dart';

class PlayerAI extends Location {

  final Body body;

  PlayerAI(this.body) ;

  @override
  VectorAI getPosition() {
    return body.position as VectorAI;
  }

  @override
  double getOrientation() {
    return body.angle;
  }

  @override
  void setOrientation(double orientation) {
    body.setTransform(getPosition(), orientation);
  }

  @override
  double vectorToAngle(VectorAI vector) {
    return Box2dSteeringUtils.vectorToAngle(vector);
  }

  @override
  VectorAI angleToVector(VectorAI outVector, double angle) {
    return Box2dSteeringUtils.angleToVector(outVector, angle);
  }

  @override
  Location newLocation() {
    return new Box2dLocation();
  }
}