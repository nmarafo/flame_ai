/* An adapter class for {@link Steerable}. You can derive from this and only override what you are interested in. For example,
 * this comes in handy when you have to create on the fly a target for a particular behavior.
 *
 * @param <T> Type of vector, either 2D or 3D, implementing the {@link Vector} interface
 *
 * @author davebaol */
import 'package:flame_ai/steer/steerable.dart';
import 'package:flame_ai/utils/location.dart';
import 'package:flame_ai/utils/vector_ai.dart';

class SteerableAdapter extends VectorAI implements Steerable {
  factory SteerableAdapter()=>SteerableAdapter();

  @override
  double getZeroLinearSpeedThreshold () {
    return 0.001;
  }

  @override
  void setZeroLinearSpeedThreshold (double value) {
  }

  @override
  double getMaxLinearSpeed () {
    return 0;
  }

  @override
  void setMaxLinearSpeed (double maxLinearSpeed) {
  }

  @override
  double getMaxLinearAcceleration () {
    return 0;
  }

  @override
  void setMaxLinearAcceleration (double maxLinearAcceleration) {
  }

  @override
  double getMaxAngularSpeed () {
    return 0;
  }

  @override
  void setMaxAngularSpeed (double maxAngularSpeed) {
  }

  @override
  double getMaxAngularAcceleration () {
    return 0;
  }

  @override
  void setMaxAngularAcceleration (double maxAngularAcceleration) {
  }

  @override
  VectorAI? getPosition () {
    return null;
  }

  @override
  double getOrientation () {
    return 0;
  }

  @override
  void setOrientation (double orientation) {
  }

  @override
  VectorAI? getLinearVelocity () {
    return null;
  }

  @override
  double getAngularVelocity () {
    return 0;
  }

  @override
  double getBoundingRadius () {
    return 0;
  }

  @override
  bool isTagged () {
    return false;
  }

  @override
  void setTagged (bool tagged) {
  }

  @override
  Location? newLocation () {
    return null;
  }

  @override
  double vectorToAngle (VectorAI vector) {
    return 0;
  }

  @override
  VectorAI? angleToVector (VectorAI outVector, double angle) {
    return null;
  }

}