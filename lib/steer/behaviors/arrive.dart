/* {@code Arrive} behavior moves the agent towards a target position. It is similar to seek but it attempts to arrive at the target
 * position with a zero velocity.
 * <p>
 * {@code Arrive} behavior uses two radii. The {@code arrivalTolerance} lets the owner get near enough to the target without
 * letting small errors keep it in motion. The {@code decelerationRadius}, usually much larger than the previous one, specifies
 * when the incoming character will begin to slow down. The algorithm calculates an ideal speed for the owner. At the slowing-down
 * radius, this is equal to its maximum linear speed. At the target point, it is zero (we want to have zero speed when we arrive).
 * In between, the desired speed is an interpolated intermediate value, controlled by the distance from the target.
 * <p>
 * The direction toward the target is calculated and combined with the desired speed to give a target velocity. The algorithm
 * looks at the current velocity of the character and works out the acceleration needed to turn it into the target velocity. We
 * can't immediately change velocity, however, so the acceleration is calculated based on reaching the target velocity in a fixed
 * time scale known as {@code timeToTarget}. This is usually a small value; it defaults to 0.1 seconds which is a good starting
 * point.
 *
 * @param <T> Type of vector, either 2D or 3D, implementing the {@link Vector} interface
 *
 * @author davebaol */
import 'package:flame_ai/steer/limiter.dart';
import 'package:flame_ai/steer/steerable.dart';
import 'package:flame_ai/steer/steering_acceleration.dart';
import 'package:flame_ai/steer/steering_behavior.dart';
import 'package:flame_ai/utils/location.dart';
import 'package:flame_ai/utils/vector_ai.dart';

class Arrive extends SteeringBehavior implements VectorAI {

  /* The target to arrive to. */
  late Location target;

  /* The tolerance for arriving at the target. It lets the owner get near enough to the target without letting small errors keep
   * it in motion. */
  late double arrivalTolerance;

  /* The radius for beginning to slow down */
  late double decelerationRadius;

  /* The time over which to achieve target speed */
  late double timeToTarget = 0.1;

  /* Creates an {@code Arrive} behavior for the specified owner.
   * @param owner the owner of this behavior */
  Arrive (Steerable owner) : super(owner);

  /* Creates an {@code Arrive} behavior for the specified owner and target.
   * @param owner the owner of this behavior
   * @param target the target of this behavior */
  Arrive.ownerAndTarget (Steerable owner, this.target) : super(owner);

  @override
  SteeringAcceleration calculateRealSteering (SteeringAcceleration steering) {
    return arrive(steering, target.getPosition());
  }

  SteeringAcceleration arrive (SteeringAcceleration steering, VectorAI targetPosition) {
    // Get the direction and distance to the target
    VectorAI toTarget = steering.linear.copyInto(targetPosition) as VectorAI;
    toTarget.sub(owner.getPosition());

    double distance = toTarget.length;

    // Check if we are there, return no steering
    if (distance <= arrivalTolerance) return steering.setZero();

    Limiter actualLimiter = getActualLimiter();
    // Go max speed
    double targetSpeed = actualLimiter.getMaxLinearSpeed();

    // If we are inside the slow down radius calculate a scaled speed
    if (distance <= decelerationRadius) targetSpeed *= distance / decelerationRadius;

    // Target velocity combines speed and direction
    VectorAI targetVelocity = toTarget.scaled(targetSpeed / distance) as VectorAI; // Optimized code for: toTarget.nor().scl(targetSpeed)

    // Acceleration tries to get to the target velocity without exceeding max acceleration
    // Notice that steering.linear and targetVelocity are the same vector
    targetVelocity.sub(owner.getLinearVelocity()!);
    targetVelocity.scaled(1 / timeToTarget);
    targetVelocity.limit(actualLimiter.getMaxLinearAcceleration());

    // No angular acceleration
    steering.angular = 0;

    // Output the steering
    return steering;
  }

  /* Returns the target to arrive to. */
  Location getTarget () {
    return target;
  }

  /* Sets the target to arrive to.
   * @return this behavior for chaining. */
  Arrive setTarget (Location target) {
    this.target = target;
    return this;
  }

  /* Returns the tolerance for arriving at the target. It lets the owner get near enough to the target without letting small
   * errors keep it in motion. */
  double getArrivalTolerance () {
    return arrivalTolerance;
  }

  /* Sets the tolerance for arriving at the target. It lets the owner get near enough to the target without letting small errors
   * keep it in motion.
   * @return this behavior for chaining. */
  Arrive setArrivalTolerance (double arrivalTolerance) {
    this.arrivalTolerance = arrivalTolerance;
    return this;
  }

  /* Returns the radius for beginning to slow down. */
  double getDecelerationRadius () {
    return decelerationRadius;
  }

  /* Sets the radius for beginning to slow down.
   * @return this behavior for chaining. */
  Arrive setDecelerationRadius (double decelerationRadius) {
    this.decelerationRadius = decelerationRadius;
    return this;
  }

  /* Returns the time over which to achieve target speed. */
  double getTimeToTarget () {
    return timeToTarget;
  }

  /* Sets the time over which to achieve target speed.
   * @return this behavior for chaining. */
  Arrive setTimeToTarget (double timeToTarget) {
    this.timeToTarget = timeToTarget;
    return this;
  }

  //
  // Setters overridden in order to fix the correct return type for chaining
  //

  @override
  Arrive setOwner (Steerable owner) {
    this.owner = owner;
    return this;
  }

  @override
  Arrive setEnabled (bool enabled) {
    this.enabled = enabled;
    return this;
  }

  /* Sets the limiter of this steering behavior. The given limiter must at least take care of the maximum linear speed and
   * acceleration.
   * @return this behavior for chaining. */
  @override
  Arrive setLimiter (Limiter limiter) {
    this.limiter = limiter;
    return this;
  }

}