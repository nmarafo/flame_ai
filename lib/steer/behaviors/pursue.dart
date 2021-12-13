/* {@code Pursue} behavior produces a force that steers the agent towards the evader (the target). Actually it predicts where an
 * agent will be in time @{code t} and seeks towards that point to intercept it. We did this naturally playing tag as children,
 * which is why the most difficult tag players to catch were those who kept switching direction, foiling our predictions.
 * <p>
 * This implementation performs the prediction by assuming the target will continue moving with the same velocity it currently
 * has. This is a reasonable assumption over short distances, and even over longer distances it doesn't appear too stupid. The
 * algorithm works out the distance between character and target and works out how long it would take to get there, at maximum
 * speed. It uses this time interval as its prediction lookahead. It calculates the position of the target if it continues to move
 * with its current velocity. This new position is then used as the target of a standard seek behavior.
 * <p>
 * If the character is moving slowly, or the target is a long way away, the prediction time could be very large. The target is
 * less likely to follow the same path forever, so we'd like to set a limit on how far ahead we aim. The algorithm has a
 * {@code maxPredictionTime} for this reason. If the prediction time is beyond this, then the maximum time is used.
 *
 * @param <T> Type of vector, either 2D or 3D, implementing the {@link Vector} interface
 *
 * @author davebaol */
import 'dart:math';

import 'package:flame_ai/steer/limiter.dart';
import 'package:flame_ai/steer/steerable.dart';
import 'package:flame_ai/steer/steering_acceleration.dart';
import 'package:flame_ai/steer/steering_behavior.dart';
import 'package:flame_ai/utils/vector_ai.dart';

class Pursue extends SteeringBehavior implements VectorAI {

  /* The target */
  late Steerable target;

  /* The maximum prediction time */
  late double maxPredictionTime;

  /* Creates a {@code Pursue} behavior for the specified owner and target. Maximum prediction time defaults to 1 second.
   * @param owner the owner of this behavior.
   * @param target the target of this behavior. */
  Pursue (Steerable owner, Steerable target) :super(owner){
    this.owner=owner;
    this.target=target;
    1;
  }

  /* Creates a {@code Pursue} behavior for the specified owner and target.
   * @param owner the owner of this behavior
   * @param target the target of this behavior
   * @param maxPredictionTime the max time used to predict the target's position assuming it continues to move with its current
   *           velocity. */
  Pursue.ownerAndTarget (Steerable owner, Steerable target, double maxPredictionTime) : super (owner){
    this.target = target;
    this.maxPredictionTime = maxPredictionTime;
  }

  /* Returns the actual linear acceleration to be applied. This method is overridden by the {@link Evade} behavior to invert the
   * maximum linear acceleration in order to evade the target. */
  double getActualMaxLinearAcceleration () {
    return getActualLimiter().getMaxLinearAcceleration();
  }

  @override
  SteeringAcceleration calculateRealSteering (SteeringAcceleration steering) {
    VectorAI targetPosition = target.getPosition();

    // Get the square distance to the evader (the target)
    steering.linear.copyInto(targetPosition);
    steering.linear.sub(owner.getPosition());
    double squareDistance = steering.linear.length2;

    // Work out our current square speed
    double squareSpeed = owner.getLinearVelocity()!.length2;

    double predictionTime = maxPredictionTime;

    if (squareSpeed > 0) {
      // Calculate prediction time if speed is not too small to give a reasonable value
      double squarePredictionTime = squareDistance / squareSpeed;
      if (squarePredictionTime < maxPredictionTime * maxPredictionTime)
        predictionTime = sqrt(squarePredictionTime);
    }

    // Calculate and seek/flee the predicted position of the target
    steering.linear.copyInto(targetPosition).scaleOrthogonalInto(predictionTime,target.getLinearVelocity()!);
    steering.linear.sub(owner.getPosition());
    steering.linear.normalized().scaled(getActualMaxLinearAcceleration());

    // No angular acceleration
    steering.angular = 0;

    // Output steering acceleration
    return steering;
  }

  /* Returns the target. */
  Steerable getTarget () {
    return target;
  }

  /* Sets the target.
   * @return this behavior for chaining. */
  Pursue setTarget (Steerable target) {
    this.target = target;
    return this;
  }

  /* Returns the maximum prediction time. */
  double getMaxPredictionTime () {
    return maxPredictionTime;
  }

  /* Sets the maximum prediction time.
   * @return this behavior for chaining. */
  Pursue setMaxPredictionTime (double maxPredictionTime) {
    this.maxPredictionTime = maxPredictionTime;
    return this;
  }

  //
  // Setters overridden in order to fix the correct return type for chaining
  //

  @override
  Pursue setOwner (Steerable owner) {
    this.owner = owner;
    return this;
  }

  @override
  Pursue setEnabled (bool enabled) {
    this.enabled = enabled;
    return this;
  }

  /* Sets the limiter of this steering behavior. The given limiter must at least take care of the maximum linear acceleration.
   * @return this behavior for chaining. */
  @override
  Pursue setLimiter (Limiter limiter) {
    this.limiter = limiter;
    return this;
  }

}