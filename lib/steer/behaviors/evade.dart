/* {@code Evade} behavior is almost the same as {@link Pursue} except that the agent flees from the estimated future position of
 * the pursuer. Indeed, reversing the acceleration is all we have to do.
 *
 * @param <T> Type of vector, either 2D or 3D, implementing the {@link Vector} interface
 *
 * @author davebaol */
import 'package:flame_ai/steer/behaviors/pursue.dart';
import 'package:flame_ai/steer/limiter.dart';
import 'package:flame_ai/steer/steerable.dart';
import 'package:flame_ai/utils/vector_ai.dart';

class Evade extends Pursue implements VectorAI {

  /* Creates a {@code Evade} behavior for the specified owner and target. Maximum prediction time defaults to 1 second.
   * @param owner the owner of this behavior
   * @param target the target of this behavior, typically a pursuer. */
  Evade (Steerable owner, Steerable target) :super(owner,target){
    this.owner=owner;
    this.target=target;
    1;
  }

  /* Creates a {@code Evade} behavior for the specified owner and pursuer.
   * @param owner the owner of this behavior
   * @param target the target of this behavior, typically a pursuer
   * @param maxPredictionTime the max time used to predict the pursuer's position assuming it continues to move with its current
   *           velocity. */
  Evade.OwnerAndPursue (Steerable owner, Steerable target, double maxPredictionTime) : super.ownerAndTarget(owner, target, maxPredictionTime);

  @override
  double getActualMaxLinearAcceleration () {
    // Simply return the opposite of the max linear acceleration so to evade the target
    return -getActualLimiter().getMaxLinearAcceleration();
  }

  //
  // Setters overridden in order to fix the correct return type for chaining
  //

  @override
  Evade setOwner (Steerable owner) {
    this.owner = owner;
    return this;
  }

  @override
  Evade setEnabled (bool enabled) {
    this.enabled = enabled;
    return this;
  }

  /* Sets the limiter of this steering behavior. The given limiter must at least take care of the maximum linear acceleration.
   * @return this behavior for chaining. */
  @override
  Evade setLimiter (Limiter limiter) {
    this.limiter = limiter;
    return this;
  }

  @override
  Evade setTarget (Steerable target) {
    this.target = target;
    return this;
  }

}