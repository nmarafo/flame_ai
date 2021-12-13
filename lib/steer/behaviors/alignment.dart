
/* {@code Alignment} is a group behavior producing a linear acceleration that attempts to keep the owner aligned with the agents in
 * its immediate area defined by the given {@link Proximity}. The acceleration is calculated by first iterating through all the
 * neighbors and averaging their linear velocity vectors. This value is the desired direction, so we just subtract the owner's
 * linear velocity to get the steering output.
 * <p>
 * Cars moving along roads demonstrate {@code Alignment} type behavior. They also demonstrate {@link Separation} as they try to
 * keep a minimum distance from each other.
 *
 * @param <T> Type of vector, either 2D or 3D, implementing the {@link Vector} interface
 *
 * @author davebaol */
import 'package:flame_ai/steer/group_behavior.dart';
import 'package:flame_ai/steer/limiter.dart';
import 'package:flame_ai/steer/proximity.dart';
import 'package:flame_ai/steer/steerable.dart';
import 'package:flame_ai/steer/steering_acceleration.dart';
import 'package:flame_ai/utils/vector_ai.dart';

class Alignment extends VectorAI implements GroupBehavior,ProximityCallback {

  VectorAI averageVelocity;

  /* Creates an {@code Alignment} behavior for the specified owner and proximity.
   * @param owner the owner of this behavior
   * @param proximity the proximity */
  Alignment (Steerable owner, Proximity proximity) : super (owner,proximity);

  @override
  SteeringAcceleration calculateRealSteering (SteeringAcceleration steering) {
    steering.setZero();

    averageVelocity = steering.linear;

    int neighborCount = proximity.findNeighbors(this);

    if (neighborCount > 0) {
      // Average the accumulated velocities
      averageVelocity.scale(1 / neighborCount);

      // Match the average velocity.
      // Notice that steering.linear and averageVelocity are the same vector here.
      averageVelocity.sub(owner.getLinearVelocity()!);
      averageVelocity.limit(getActualLimiter().getMaxLinearAcceleration());
    }

    return steering;
  }

  @override
  bool reportNeighbor (Steerable neighbor) {
    // Accumulate neighbor velocity
    averageVelocity.add(neighbor.getLinearVelocity()!);
    return true;
  }

  //
  // Setters overridden in order to fix the correct return type for chaining
  //

  @override
  Alignment setOwner (Steerable owner) {
    this.owner = owner;
    return this;
  }

  @override
  Alignment setEnabled (bool enabled) {
    this.enabled = enabled;
    return this;
  }

  /* Sets the limiter of this steering behavior. The given limiter must at least take care of the maximum linear acceleration.
   * @return this behavior for chaining. */
  @override
  Alignment setLimiter (Limiter limiter) {
    this.limiter = limiter;
    return this;
  }

}