import 'package:flame_ai/utils/location.dart';
import 'package:flame_ai/utils/vector_ai.dart';
import 'package:flame_ai_example/utils/box2d_steering_utils.dart';

class Box2dLocation extends Location{

  late VectorAI position;
  late double orientation;

  Box2dLocation() {
    position = new VectorAI();
    orientation = 0;
  }

  @override
  VectorAI getPosition() {
    return position;
  }

  @override
  double getOrientation() {
    return orientation;
  }

  @override
  void setOrientation(double orientation) {
    this.orientation = orientation;
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