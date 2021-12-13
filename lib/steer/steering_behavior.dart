
/* A {@code SteeringBehavior} calculates the linear and/or angular accelerations to be applied to its owner.
 *
 * @param <T> Type of vector, either 2D or 3D, implementing the {@link Vector} interface
 *
 * @author davebaol */
import 'package:flame/extensions.dart';
import 'package:flame_ai/steer/limiter.dart';
import 'package:flame_ai/steer/steerable.dart';
import 'package:flame_ai/steer/steering_acceleration.dart';
import 'package:flame_ai/utils/location.dart';

abstract class SteeringBehavior extends Vector2 {

  /* The owner of this steering behavior */
  late Steerable owner;

  /* The limiter of this steering behavior */
  Limiter? limiter;

  /* A flag indicating whether this steering behavior is enabled or not. */
  late bool enabled;

  /* Creates a {@code SteeringBehavior} for the specified owner. The behavior is enabled and has no explicit limiter, meaning
   * that the owner is used instead.
   *
   * @param owner the owner of this steering behavior */
  factory SteeringBehavior (Steerable owner) =>
      SteeringBehavior(owner)
        ..limiter=null
        ..enabled=true;

  /* Creates a {@code SteeringBehavior} for the specified owner and limiter. The behavior is enabled.
   *
   * @param owner the owner of this steering behavior
   * @param limiter the limiter of this steering behavior */
  factory SteeringBehavior.ownerAndLimiter (Steerable owner, Limiter limiter) =>
      SteeringBehavior(owner)
        ..limiter=limiter
        ..enabled=true;

  /* Creates a {@code SteeringBehavior} for the specified owner and activation flag. The behavior has no explicit limiter,
   * meaning that the owner is used instead.
   *
   * @param owner the owner of this steering behavior
   * @param enabled a flag indicating whether this steering behavior is enabled or not */
  factory SteeringBehavior.ownerAndEnabled (Steerable owner, bool enabled) =>
      SteeringBehavior(owner)
        ..limiter=null
        ..enabled=enabled;

  /* Creates a {@code SteeringBehavior} for the specified owner, limiter and activation flag.
   *
   * @param owner the owner of this steering behavior
   * @param limiter the limiter of this steering behavior
   * @param enabled a flag indicating whether this steering behavior is enabled or not */
  factory SteeringBehavior.ownerLimitedEnabled (Steerable owner, Limiter limiter, bool enabled) =>
      SteeringBehavior(owner)
        ..limiter=limiter
        ..enabled=enabled;

  /* If this behavior is enabled calculates the steering acceleration and writes it to the given steering output. If it is
   * disabled the steering output is set to zero.
   * @param steering the steering acceleration to be calculated.
   * @return the calculated steering acceleration for chaining. */
  SteeringAcceleration calculateSteering (SteeringAcceleration steering) {
    return isEnabled() ? calculateRealSteering(steering) : steering.setZero();
  }

  /* Calculates the steering acceleration produced by this behavior and writes it to the given steering output.
   * <p>
   * This method is called by {@link #calculateSteering(SteeringAcceleration)} when this steering behavior is enabled.
   * @param steering the steering acceleration to be calculated.
   * @return the calculated steering acceleration for chaining. */
  SteeringAcceleration calculateRealSteering (SteeringAcceleration steering);

  /* Returns the owner of this steering behavior. */
  Steerable getOwner () {
    return owner;
  }

  /* Sets the owner of this steering behavior.
   * @return this behavior for chaining. */
  SteeringBehavior setOwner (Steerable owner) {
    this.owner = owner;
    return this;
  }

  /* Returns the limiter of this steering behavior. */
  Limiter getLimiter () {
    return limiter!;
  }

  /* Sets the limiter of this steering behavior.
   * @return this behavior for chaining. */
  SteeringBehavior setLimiter (Limiter limiter) {
    this.limiter = limiter;
    return this;
  }

  /* Returns true if this steering behavior is enabled; false otherwise. */
  bool isEnabled () {
    return enabled;
  }

  /* Sets this steering behavior on/off.
   * @return this behavior for chaining. */
  SteeringBehavior setEnabled (bool enabled) {
    this.enabled = enabled;
    return this;
  }

  /* Returns the actual limiter of this steering behavior. */
  Limiter getActualLimiter () {
    return limiter! == null ? owner : limiter!;
  }

  /* Utility method that creates a new vector.
   * <p>
   * This method is used internally to instantiate vectors of the correct type parameter {@code T}. This technique keeps the API
   * simple and makes the API easier to use with the GWT backend because avoids the use of reflection.
   *
   * @param location the location whose position is used to create the new vector
   * @return the newly created vector */
  Vector2 newVector (Location location) {
    return location.getPosition().cpy().setZero();
  }
}