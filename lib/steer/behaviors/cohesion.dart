/* {@code Cohesion} is a group behavior producing a linear acceleration that attempts to move the agent towards the center of mass
 * of the agents in its immediate area defined by the given {@link Proximity}. The acceleration is calculated by first iterating
 * through all the neighbors and averaging their position vectors. This gives us the center of mass of the neighbors, the place
 * the agents wants to get to, so it seeks to that position.
 * <p>
 * A sheep running after its flock is demonstrating cohesive behavior. Use this behavior to keep a group of agents together.
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

class Cohesion extends GroupBehavior implements VectorAI,ProximityCallback {

  late VectorAI centerOfMass;

  /* Creates a {@code Cohesion} for the specified owner and proximity.
   * @param owner the owner of this behavior.
   * @param proximity the proximity to detect the owner's neighbors */
  Cohesion (Steerable owner, Proximity proximity) : super(owner, proximity);

  @override
  SteeringAcceleration calculateRealSteering (SteeringAcceleration steering) {

    steering.setZero();

    centerOfMass = steering.linear;

    int neighborCount = proximity.findNeighbors(this);

    if (neighborCount > 0) {

      // The center of mass is the average of the sum of positions
      centerOfMass.scaled(1 / neighborCount);

      // Now seek towards that position.
      centerOfMass.sub(owner.getPosition());
      centerOfMass.normalized().scaled(getActualLimiter().getMaxLinearAcceleration());
    }

    return steering;
  }

  @override
  bool reportNeighbor (Steerable neighbor) {
    // Accumulate neighbor position
    centerOfMass.add(neighbor.getPosition());
    return true;
  }

  //
  // Setters overridden in order to fix the correct return type for chaining
  //

  @override
  Cohesion setOwner (Steerable owner) {
    this.owner = owner;
    return this;
  }

  @override
  Cohesion setEnabled (bool enabled) {
    this.enabled = enabled;
    return this;
  }

  /* Sets the limiter of this steering behavior. The given limiter must at least take care of the maximum linear acceleration.
   * @return this behavior for chaining. */
  @override
  Cohesion setLimiter (Limiter limiter) {
    this.limiter = limiter;
    return this;
  }
}