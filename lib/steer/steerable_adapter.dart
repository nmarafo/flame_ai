/* An adapter class for {@link Steerable}. You can derive from this and only override what you are interested in. For example,
 * this comes in handy when you have to create on the fly a target for a particular behavior.
 *
 * @param <T> Type of vector, either 2D or 3D, implementing the {@link Vector} interface
 *
 * @author davebaol */
import 'package:flame/extensions.dart';
import 'package:flame_ai/steer/steerable.dart';
import 'package:flame_ai/utils/location.dart';

class SteerableAdapter extends Vector2 implements Steerable {
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
  Vector2? getPosition () {
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
  Vector2? getLinearVelocity () {
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
  double vectorToAngle (Vector2 vector) {
    return 0;
  }

  @override
  Vector2? angleToVector (Vector2 outVector, double angle) {
    return null;
  }

}