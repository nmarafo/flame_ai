
/* {@code SteeringAcceleration} is a movement requested by the steering system. It is made up of two components, linear and angular
 * acceleration.
 *
 * @param <T> Type of vector, either 2D or 3D, implementing the {@link Vector} interface
 *
 * @author davebaol */
import 'dart:math';

import 'package:flame/extensions.dart';
import 'package:flame_ai/utils/vector_ai.dart';

class SteeringAcceleration extends VectorAI {
  /* The linear component of this steering acceleration. */
  late VectorAI linear;

  /* The angular component of this steering acceleration. */
  late double angular;

  /* Creates a {@code SteeringAcceleration} with the given linear acceleration and zero angular acceleration.
   *
   * @param linear The initial linear acceleration to give this SteeringAcceleration. */
  SteeringAcceleration (this.linear) {
    angular=0;
  }

  /* Creates a {@code SteeringAcceleration} with the given linear and angular components.
   *
   * @param linear The initial linear acceleration to give this SteeringAcceleration.
   * @param angular The initial angular acceleration to give this SteeringAcceleration. */
  SteeringAcceleration.linearAndAngular (this.linear, this.angular);

  /* Returns {@code true} if both linear and angular components of this steering acceleration are zero; {@code false} otherwise. */
  bool isZero () {
    return angular == 0 && linear==Vector2(0,0);
  }

  /* Zeros the linear and angular components of this steering acceleration.
   * @return this steering acceleration for chaining */
  SteeringAcceleration setZero () {
    linear.setZero();
    angular = 0;
    return this;
  }

  /* Adds the given steering acceleration to this steering acceleration.
   *
   * @param steering the steering acceleration
   * @return this steering acceleration for chaining */
  SteeringAcceleration addSteering (SteeringAcceleration steering) {
    linear.add(steering.linear);
    angular += steering.angular;
    return this;
  }

  /* Scales this steering acceleration by the specified scalar.
   *
   * @param scalar the scalar
   * @return this steering acceleration for chaining */
  SteeringAcceleration scl (double scalar) {
    linear.scale(scalar);
    angular *= scalar;
    return this;
  }

  /* First scale a supplied steering acceleration, then add it to this steering acceleration.
   *
   * @param steering the steering acceleration
   * @param scalar the scalar
   * @return this steering acceleration for chaining */
  SteeringAcceleration mulAdd (SteeringAcceleration steering, double scalar) {
    linear.scaleOrthogonalInto(scalar,steering.linear);
    angular += steering.angular * scalar;
    return this;
  }

  /* Returns the square of the magnitude of this steering acceleration. This includes the angular component. */
  double calculateSquareMagnitude () {
    return linear.length2 + angular * angular;
  }

  /* Returns the magnitude of this steering acceleration. This includes the angular component. */
  double calculateMagnitude () {
    return sqrt(calculateSquareMagnitude());
  }
}