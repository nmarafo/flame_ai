/* This combination behavior simply sums up all the behaviors, applies their weights, and truncates the result before returning.
 * There are no constraints on the blending weights; they don't have to sum to one, for example, and rarely do. Don't think of
 * {@code BlendedSteering} as a weighted mean, because it's not.
 * <p>
 * With {@code BlendedSteering} you can combine multiple behaviors to get a more complex behavior. It can work fine, but the
 * trade-off is that it comes with a few problems:
 * <ul>
 * <li>Since every active behavior is calculated every time step, it can be a costly method to process.</li>
 * <li>Behavior weights can be difficult to tweak. There have been research projects that have tried to evolve the steering
 * weights using genetic algorithms or neural networks. Results have not been encouraging, however, and manual experimentation
 * still seems to be the most sensible approach.</li>
 * <li>It's problematic with conflicting forces. For instance, a common scenario is where an agent is backed up against a wall by
 * several other agents. In this example, the separating forces from the neighboring agents can be greater than the repulsive
 * force from the wall and the agent can end up being pushed through the wall boundary. This is almost certainly not going to be
 * favorable. Sure you can make the weights for the wall avoidance huge, but then your agent may behave strangely next time it
 * finds itself alone and next to a wall.</li>
 * </ul>
 *
 * @param <T> Type of vector, either 2D or 3D, implementing the {@link Vector} interface
 *
 * @author davebaol */
import 'package:flame_ai/steer/limiter.dart';
import 'package:flame_ai/steer/steerable.dart';
import 'package:flame_ai/steer/steering_acceleration.dart';
import 'package:flame_ai/steer/steering_behavior.dart';
import 'package:flame_ai/utils/vector_ai.dart';

class BlendedSteering extends SteeringBehavior implements VectorAI {

  /* The list of behaviors and their corresponding blending weights. */
  late List<BehaviorAndWeight> list;

  late SteeringAcceleration steering;

  /* Creates a {@code BlendedSteering} for the specified {@code owner}, {@code maxLinearAcceleration} and
   * {@code maxAngularAcceleration}.
   * @param owner the owner of this behavior. */
  BlendedSteering (Steerable owner) : super(owner){
    this.list = <BehaviorAndWeight>[];
    this.steering = SteeringAcceleration(newVector(owner));
  }

  /* Adds a steering behavior and its weight to the list.
   * @param behavior the steering behavior to add
   * @param weight the weight of the behavior
   * @return this behavior for chaining. */
  BlendedSteering addSteeringAndWeight (SteeringBehavior behavior, double weight) {
    return addBehaviourAndWeight(BehaviorAndWeight(behavior, weight));
  }

  /* Adds a steering behavior and its weight to the list.
   * @param item the steering behavior and its weight
   * @return this behavior for chaining. */
  BlendedSteering addBehaviourAndWeight (BehaviorAndWeight item) {
    item.behavior.setOwner(owner);
    list.add(item);
    return this;
  }

  /* Removes a steering behavior from the list.
   * @param item the steering behavior to remove */
  void remove (BehaviorAndWeight item) {
    list.remove(item);
  }

  /* Removes a steering behavior from the list.
   * @param behavior the steering behavior to remove */
  void removeSteeringBehaviour (SteeringBehavior behavior) {
    for (int i = 0; i < list.length; i++) {
      if(list.elementAt(i).behavior == behavior) {
        list.removeAt(i);
        return;
      }
    }
  }

  /* Returns the weighted behavior at the specified index.
   * @param index the index of the weighted behavior to return */
  BehaviorAndWeight get (int index) {
    return list.elementAt(index);
  }

  @override
  SteeringAcceleration calculateRealSteering (SteeringAcceleration blendedSteering) {
    // Clear the output to start with
    blendedSteering.setZero();

    // Go through all the behaviors
    int len = list.length;
    for (int i = 0; i < len; i++) {
      BehaviorAndWeight bw = list.elementAt(i);

      // Calculate the behavior's steering
      bw.behavior.calculateSteering(steering);

      // Scale and add the steering to the accumulator
      blendedSteering.mulAdd(steering, bw.weight);
    }

    Limiter actualLimiter = getActualLimiter();

    // Crop the result
    blendedSteering.linear.limit(actualLimiter.getMaxLinearAcceleration());
    if (blendedSteering.angular > actualLimiter.getMaxAngularAcceleration())
      blendedSteering.angular = actualLimiter.getMaxAngularAcceleration();

    return blendedSteering;
  }

  //
  // Setters overridden in order to fix the correct return type for chaining
  //

  @override
  BlendedSteering setOwner (Steerable owner) {
    this.owner = owner;
    return this;
  }

  @override
  BlendedSteering setEnabled (bool enabled) {
    this.enabled = enabled;
    return this;
  }

  /* Sets the limiter of this steering behavior. The given limiter must at least take care of the maximum linear and angular
   * accelerations. You can use {@link NullLimiter#NEUTRAL_LIMITER} to avoid all truncations.
   * @return this behavior for chaining. */
  @override
  BlendedSteering setLimiter (Limiter limiter) {
    this.limiter = limiter;
    return this;
  }
}

//
// Nested classes
//

class BehaviorAndWeight extends VectorAI {

  late SteeringBehavior behavior;
  late double weight;

  BehaviorAndWeight (SteeringBehavior behavior, double weight) {
    this.behavior = behavior;
    this.weight = weight;
  }

  SteeringBehavior getBehavior () {
    return behavior;
  }

  void setBehavior (SteeringBehavior behavior) {
    this.behavior = behavior;
  }

  double getWeight () {
    return weight;
  }

  void setWeight (double weight) {
    this.weight = weight;
  }
}